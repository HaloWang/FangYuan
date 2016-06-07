//
//  ConstraintManager.swift
//  FangYuan
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import UIKit

// MARK: - Init & Properties

/// 约束依赖管理者
class ConstraintManager {
    
    private init() {}
    static let singleton = ConstraintManager()
    
    var holder = ConstraintHolder()
    
    // TODO: 重要的还是做到按照 superview 分组遍历以提高性能
    // TODO: 有没有集散型的并发遍历？

    var unsetConstraints = Set<Constraint>()
    var storedConstraints = Set<Constraint>()
}

// MARK: - Public Methods
extension ConstraintManager {

    /**
     从某个视图得到约束
     
     - parameter from:      约束依赖视图
     - parameter direction: 约束方向
     */
    class func pushConstraintFrom(from:UIView, direction: Constraint.Direction) {
        
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)

        let newConstraint = Constraint(from: from, to: nil, direction: direction)
        singleton.holder.push(newConstraint, at: direction)
    }

    // TODO: setConstraint 是生成『渲染队列』的最佳时机了吧
    // TODO: 这个『渲染队列』还可以抽象成一个专门计算高度的类方法？

    /**
     设定约束到某个视图上
     
     - parameter to:        约束目标
     - parameter direction: 约束方向
     - parameter value:     约束固定值
     */
    class func popConstraintTo(to:UIView, direction: Constraint.Direction, value:CGFloat) {
        
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)
        
        //  这个方法应该被优先调用，可能出现 fy_XXX(a) 替换 fy_XXX(chainXXX) 的情况
        singleton.removeDuplicateConstraintOf(to, at: direction)
        
        //  如果对应方向上没有 holder，则认为 fy_XXX() 的参数中没有调用 chainXXX，直接返回，不进行后续操作
        guard let _constraint = singleton.holder.popConstraintAt(direction) else {
            return
        }
        
        _constraint.to = to
        _constraint.value = value
        singleton.unsetConstraints.insert(_constraint)
        singleton.holder.clearConstraintAt(direction)
        
        assert(singleton.noConstraintCirculationWith(_constraint),
                "There is a constraint circulation between\n\(to)\n- and -\n\(_constraint.from)\n".fy_alert)
    }

    class func layout(view:UIView) {
        
        let info = view.usingFangYuanInfo

        guard info.hasUsingFangYuanSubview else {
            return
        }
        
        _fy_waitLayoutQueue()
        singleton.layout(info.usingFangYuanSubviews)
    }
    
    /// 当某个依赖发生变化时，寻找相关的依赖，并重新根据存储的值赋值
    /// 为了能保证『自动重置相关约束』，这个方法会在 `UIView.fy_XXX` 时从 `settedConstraints` 中检查相关的约束。
    /// 并将其从新添加到 `constraints` 中
    ///
    /// - Important: 
    /// 这里面已经产生了递归调用了：fy_XXX -> [This Method] -> fy_XXX -> [This Method] -> ...
    /// 这样可以保证每次设定了约束了之后，所有与之相关的约束都会被重新设定
    /// - TODO: 部分方法不应该遍历两次的！这里的性能还有提升空间
    /// - TODO: horizontal 的意义并不明显啊
    class func resetRelatedConstraintFrom(view:UIView, isHorizontal horizontal:Bool) {
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)
        singleton.storedConstraints.forEach { constraint in
            if let _from = constraint.from {
                if _from == view {
                    if horizontal == constraint.direction.horizontal {
                        switch constraint.direction {
                        case .RightLeft:
                            constraint.to.fy_left(view.chainRight + constraint.value)
                        case .LeftRigt:
                            constraint.to.fy_right(view.chainLeft + constraint.value)
                        case .BottomTop:
                            constraint.to.fy_top(view.chainBottom + constraint.value)
                        case .TopBottom:
                            constraint.to.fy_bottom(view.chainTop + constraint.value)
                        }
                    }
                }
            } else {
                singleton.storedConstraints.remove(constraint)
            }
        }
    }
}

// MARK: - Private Methods

// MARK: Layout
private extension ConstraintManager {

    // TODO: UITableView.addSubiew 后，调用 UITableView 的 layoutSubviews 并不会被触发？
    
    /// 核心布局方法
    func layout(views: [UIView]) {
        
        assert(NSThread.isMainThread(), _fy_MainQueueAssert)
        
        guard hasUnsetConstraints(unsetConstraints, of: views) else {
            views.forEach { view in
                view.layoutWithFangYuan()
            }
            return
        }
        
        var layoutingViews = Set(views)
        //  注意，应该保证下面的代码在执行时，不能直接遍历 constraints 来设定 layoutingViews，因为 _fangyuan_layout_queue 可能会对 layoutingViews 中的 UIView 添加新的约束，导致 hasSetConstraints 始终为 false
        var layoutingConstraint = unsetConstraints
        var shouldRepeat: Bool
        repeat {
            shouldRepeat = false
            layoutingViews.forEach { view in
                if hasSetConstraints(layoutingConstraint, to: view) {
                    view.layoutWithFangYuan()
                    layoutingConstraint = setConstraints(layoutingConstraint, from: view)
                    //  在被遍历的数组中移除该 view
                    layoutingViews.remove(view)
                } else {
                    shouldRepeat = true
                }
            }
        } while shouldRepeat
    }
    
    func hasUnsetConstraints(cons:Set<Constraint>, of views:[UIView]) -> Bool {
        guard cons.count != 0 else {
            return false
        }
        
        // TODO: 外层遍历遍历谁会更快？或者两个一起遍历？
        for view in views {
            if !hasSetConstraints(cons, to: view) {
                return true
            }
        }
        
        return false
    }
    
    /// 给定的约束中，已经没有用来约束 view 的约束了
    func hasSetConstraints(cons:Set<Constraint>, to view:UIView) -> Bool {
        for con in cons {
            if con.to == view {
                return false
            }
        }
        return true
    }

    /// 确定了该 UIView.frame 后，装载指定 Constraint 至 to.ruler.section 中
    // TODO: 参数可变性还是一个问题！
    func setConstraints(cons:Set<Constraint>, from view: UIView) -> Set<Constraint> {
        var _cons = cons
        _cons.forEach { constraint in
            if constraint.from == view {
                let _from = constraint.from
                let _to = constraint.to
                let _value = constraint.value
                switch constraint.direction {
                case .BottomTop:
                    _to.rulerY.a = _from.frame.origin.y + _from.frame.height + _value
                case .TopBottom:
                    _to.rulerY.c = _from.superview!.frame.height - _from.frame.origin.y + _value
                case .RightLeft:
                    _to.rulerX.a = _from.frame.origin.x + _from.frame.width + _value
                case .LeftRigt:
                    _to.rulerX.c = _from.superview!.frame.width - _from.frame.origin.x + _value
                }
                _cons.remove(constraint)
                _fy_layoutQueue {
                    self.setSettedConstraint(constraint)
                }
            }
        }
        return _cons
    }
}

// MARK: Assistant
private extension ConstraintManager {
    
    func setSettedConstraint(constraint:Constraint) {
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)
        storedConstraints.forEach { con in
            if con.to == nil || con.from == nil {
                storedConstraints.remove(con)
            } else if con.to == constraint.to && con.direction == constraint.direction {
                storedConstraints.remove(con)
            }
        }
        storedConstraints.insert(constraint)
    }

    /// 按照程序逻辑，一个 view 最多同时只能在一个方向上拥有一个约束
    func removeDuplicateConstraintOf(view:UIView, at direction: Constraint.Direction) {
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)
        unsetConstraints.forEach { con in
            if con.to == nil || con.from == nil {
                unsetConstraints.remove(con)
            } else if con.to == view && con.direction == direction {
                unsetConstraints.remove(con)
            }
        }
    }
    
    func noConstraintCirculationWith(constraint:Constraint) -> Bool {
        assert(!NSThread.isMainThread(), _fy_noMainQueueAssert)
        return unsetConstraints.filter {
            $0 <=> constraint
        }.count == 0
    }
    
}

