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
    
    fileprivate init() {}
    static let singleton = ConstraintManager()
    
    var holder = ConstraintHolder()
    
    /// - Todo: 重要的还是做到按照 superview 分组遍历以提高性能
    /// - Todo: 有没有集散型的并发遍历？

    /// 还没有被赋值到 UIView.Ruler 上的约束
    var unsetConstraints = Set<Constraint>()
    
    /// 已经被设定好的，存储起来的约束，用于以后抽取出来再次使用
    var storedConstraints = Set<Constraint>()
}

// MARK: - Public Methods
extension ConstraintManager {

    /**
     从某个视图得到约束
     
     - parameter from:      约束依赖视图
     - parameter section:   约束区间
     */
    class func pushConstraintFrom(_ from:UIView, section: Constraint.Section) {
        
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)

        let newConstraint = Constraint(from: from, to: nil, section: section)
        singleton.holder.set(newConstraint, at: section)
    }

    /// - Todo: setConstraint 是生成『渲染队列』的最佳时机了吧
    /// - Todo: 这个『渲染队列』还可以抽象成一个专门计算高度的类方法？

    /**
     设定约束到某个视图上
     
     - parameter to:        约束目标
     - parameter section:   约束区间
     - parameter value:     约束固定值
     */
    class func popConstraintTo(_ to:UIView, section: Constraint.Section, value:CGFloat) {
        
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)
        
        //  这个方法应该被优先调用，可能出现 fy_XXX(a) 替换 fy_XXX(chainXXX) 的情况
        singleton.removeDuplicateConstraintOf(to, at: section)
        
        //  如果对应区间上没有 holder，则认为 fy_XXX() 的参数中没有调用 chainXXX，直接返回，不进行后续操作
        guard let _constraint = singleton.holder.constraintAt(section) else {
            return
        }
        
        _constraint.to = to
        _constraint.value = value
        singleton.unsetConstraints.insert(_constraint)
        singleton.holder.clearConstraintAt(section)
        
        assert(singleton.noConstraintCirculationWith(_constraint),
                "There is a constraint circulation between\n\(to)\n- and -\n\(_constraint.from)\n".fy_alert)
    }

    class func layout(_ view:UIView) {
        
        let usingFangYuanSubviews = view.usingFangYuanSubviews
        guard usingFangYuanSubviews.count > 0 else {
            return
        }
        _fy_waitLayoutQueue()
        singleton.layout(usingFangYuanSubviews)
        
    }
    
    /// 当某个依赖发生变化时，寻找相关的依赖，并重新根据存储的值赋值
    /// 为了能保证『自动重置相关约束』，这个方法会在 `UIView.fy_XXX` 时从 `settedConstraints` 中检查相关的约束。
    /// 并将其从新添加到 `constraints` 中
    ///
    /// - Important: 
    /// 这里面已经产生了递归调用了：fy_XXX -> [This Method] -> fy_XXX -> [This Method] -> ...
    /// 这样可以保证每次设定了约束了之后，所有与之相关的约束都会被重新设定
    /// - Todo: 部分方法不应该遍历两次的！这里的性能还有提升空间
    /// - Todo: horizontal 的意义并不明显啊
    class func resetRelatedConstraintFrom(_ view:UIView, isHorizontal horizontal:Bool) {
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)
        singleton.storedConstraints.forEach { constraint in
            if let _from = constraint.from , _from == view {
                if horizontal == constraint.section.horizontal {
                    switch constraint.section {
                    case .left:
                        constraint.to.fy_left(view.chainRight + constraint.value)
                    case .right:
                        constraint.to.fy_right(view.chainLeft + constraint.value)
                    case .top:
                        constraint.to.fy_top(view.chainBottom + constraint.value)
                    case .bottom:
                        constraint.to.fy_bottom(view.chainTop + constraint.value)
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

// MARK: Layout
private extension ConstraintManager {

    /// - Todo: UITableView.addSubiew 后，调用 UITableView 的 layoutSubviews 并不会被触发？
    
    /// 核心布局方法
    /// - Todo: 这个算法相当于使用了什么排序？
    /// - Todo: 能不能尽量写成函数而非方法？
    /// - Todo: 还是把两部分合并一下，整理成一步算法吧
    func layout(_ views: [UIView]) {
        
        assert(Thread.isMainThread, _fy_MainQueueAssert)
        
        guard hasUnsetConstraints(unsetConstraints, of: views) else {
            views.forEach { view in
                view.layoutWithFangYuan()
            }
            return
        }
        
        //  注意，应该保证下面的代码在执行时，不能直接遍历 constraints 来设定 layoutingViews，因为 _fangyuan_layout_queue 可能会对 layoutingViews 中的 UIView 添加新的约束，导致 hasSetConstraints 始终为 false
        //  当然，objc_sync_enter 也是一种解决方案，但是这里我并不想阻塞 _fangyuan_layout_queue 对 unsetConstraints 的访问
        var _views = Set(views)
        var constraints = unsetConstraints
        var shouldRepeat: Bool
        repeat {
            shouldRepeat = false
            _views.forEach { view in
                if hasSetConstraints(constraints, to: view) {
                    view.layoutWithFangYuan()
                    constraints = setConstraints(constraints, from: view)
                    //  在被遍历的数组中移除该 view
                    _views.remove(view)
                } else {
                    shouldRepeat = true
                }
            }
        } while shouldRepeat
    }
    
    func hasUnsetConstraints(_ constraints:Set<Constraint>, of views:[UIView]) -> Bool {
        guard constraints.count != 0 else {
            return false
        }
        
        /// - Todo: 外层遍历遍历谁会更快？或者两个一起遍历？
        for view in views {
            if !hasSetConstraints(constraints, to: view) {
                return true
            }
        }
        
        return false
    }
    
    /// 给定的约束中，已经没有用来约束 view 的约束了
    func hasSetConstraints(_ constraints:Set<Constraint>, to view:UIView) -> Bool {
        for constraint in constraints {
            //  ⚠️ Crash
            //  "fatal error: unexpectedly found nil while unwrapping an Optional value"
            //  `constraint.to` is nil
            if constraint.to == view {
                return false
            }
        }
        return true
    }

    /// 确定了该 UIView.frame 后，装载指定 Constraint 至 to.ruler.section 中
    /// - Todo: 参数可变性还是一个问题！
    func setConstraints(_ constraints:Set<Constraint>, from view: UIView) -> Set<Constraint> {
        var _constraints = constraints
        _constraints.forEach { constraint in
            if constraint.from == view {
                _fy_layoutQueue {
                    self.storedConstraintsInsert(constraint)
                }
                let _from = constraint.from
                let _to = constraint.to
                let _value = constraint.value
                switch constraint.section {
                case .top:
                    _to?.rulerY.a = (_from?.frame.origin.y)! + (_from?.frame.height)! + _value
                case .bottom:
                    _to?.rulerY.c = (_from?.superview!.frame.height)! - (_from?.frame.origin.y)! + _value
                case .left:
                    _to?.rulerX.a = (_from?.frame.origin.x)! + (_from?.frame.width)! + _value
                case .right:
                    _to?.rulerX.c = (_from?.superview!.frame.width)! - (_from?.frame.origin.x)! + _value
                }
                _constraints.remove(constraint)
            }
        }
        return _constraints
    }
}

// MARK: Assistant
private extension ConstraintManager {
    
    func storedConstraintsInsert(_ constraint:Constraint) {
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)
        storedConstraints.forEach { constraint in
            if constraint.to == nil || constraint.from == nil {
                storedConstraints.remove(constraint)
            } else if constraint.to == constraint.to && constraint.section == constraint.section {
                storedConstraints.remove(constraint)
            }
        }
        storedConstraints.insert(constraint)
    }

    /// 按照程序逻辑，一个 view 最多同时只能在一个区间上拥有一个约束
    func removeDuplicateConstraintOf(_ view:UIView, at section: Constraint.Section) {
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)
        unsetConstraints.forEach { constraint in
            if constraint.to == nil || constraint.from == nil {
                unsetConstraints.remove(constraint)
            } else if constraint.to == view && constraint.section == section {
                unsetConstraints.remove(constraint)
            }
        }
    }
    
    /// Check constraint circulation
    ///
    /// - Todo: Only 2 ? What about 3, 4, 5...?
    func noConstraintCirculationWith(_ constraint:Constraint) -> Bool {
        assert(!Thread.isMainThread, _fy_noMainQueueAssert)
        return unsetConstraints.filter {
            $0.to == constraint.from && $0.from == constraint.to
        }.count == 0
    }
    
}

