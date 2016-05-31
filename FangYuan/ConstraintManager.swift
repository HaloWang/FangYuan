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
///
/// 可能做着做着就成了 `AsyncDisplayKit` 那样抽取布局树，异步计算布局的东西了
class ConstraintManager {
    
    private init() {}
    static let singleton = ConstraintManager()
    
    // TODO: 根据正在布局的 UIView 对 constraints 按组遍历
    var constraints = Set<Constraint>()
    
    var holder = ConstraintHolder()
    
    var viewTree = ViewTree()
    
    weak var layoutingView : UIView?
    
    class ConstraintHolder {
        var topBottom: Constraint?
        var bottomTop: Constraint?
        var leftRight: Constraint?
        var rightLeft: Constraint?
        
        func popConstraintAt(direction: Constraint.Direction) -> Constraint? {
            switch direction {
            case .TopBottom:
                return topBottom
            case .BottomTop:
                return bottomTop
            case .LeftRigt:
                return leftRight
            case .RightLeft:
                return rightLeft
            }
        }
        
        func push(constraint:Constraint?, at direction:Constraint.Direction) {
            switch direction {
            case .TopBottom:
                topBottom = constraint
            case .BottomTop:
                bottomTop = constraint
            case .LeftRigt:
                leftRight = constraint
            case .RightLeft:
                rightLeft = constraint
            }
        }
        
        func clearConstraintAt(direction: Constraint.Direction) {
            push(nil, at: direction)
        }
    }
}

// MARK: - Public Methods
extension ConstraintManager {

    /**
     从某个视图得到约束
     
     - parameter from:      约束依赖视图
     - parameter direction: 约束方向
     */
    class func pushConstraintFrom(from:UIView, direction: Constraint.Direction) {
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
        
        //  这个方法应该被优先调用，可能出现 fy_XXX(a) 替换 fy_XXX(chainXXX) 的情况
        singleton.removeDuplicateConstraintOf(to, at: direction)
        
        //  如果对应方向上没有 holder，则认为 fy_XXX() 的参数中没有调用 chainXXX，直接返回，不进行后续操作
        guard let _constraint = singleton.holder.popConstraintAt(direction) else {
            return
        }
        
        _constraint.to = to
        _constraint.value = value
        checkCyclingConstraintWith(_constraint)
        singleton.constraints.insert(_constraint)
        singleton.holder.clearConstraintAt(direction)
    }

    class func layout(view:UIView) {
        
        let info = view.usingFangYuanInfo
        
        singleton.layoutingView = view

        guard info.hasUsingFangYuanSubview else {
            return
        }

        singleton.layout(info.usingFangYuanSubviews)
    }
}

// MARK: - Private Methods

// MARK: Layout
private extension ConstraintManager {

    // TODO: UITableView.addSubiew 后，调用 UITableView 的 layoutSubviews 并不会被触发？
    // TODO: 😇面对需要重新设定 UIView.constraint 的问题，可以再次套用一遍这个方法
    
    /// 核心布局方法
    func layout(views: [UIView]) {
        
        guard hasUnsetConstraintsOf(views) else {
            views.forEach { view in
                view.layoutWithFangYuan()
            }
            return
        }
        
        var weakViews = [WeakView]()
        var layoutingViews = Set(views)
        //  未设定的约束中，发现有用来约束 view 的约束
        var shouldRepeat: Bool
        repeat {
            shouldRepeat = false
            layoutingViews.forEach { view in
                if hasSetConstrainTo(view) {
                    view.layoutWithFangYuan()
                    setConstraintsFrom(view)
                    //  在被遍历的数组中移除该 view
                    weakViews.append(WeakView(view))
                    layoutingViews.remove(view)
                } else {
                    shouldRepeat = true
                }
            }
        } while shouldRepeat
        
        //  UIView 的关系是树形结构，UIView.constraint 之间的约束关系也是树形结构！
        //  N 叉树
        //  所以这里就涉及到算法了！
        
        viewTree[WeakView(layoutingView!)] = weakViews
    }

    func hasUnsetConstraintsOf(views:[UIView]) -> Bool {

        guard constraints.count != 0 else {
            return false
        }
        
        // TODO: 外层遍历遍历谁会更快？或者两个一起遍历？

        for view in views {
            if !hasSetConstrainTo(view) {
                return true
            }
        }

        return false
    }

    /// 未设定的约束中，已经没有用来约束 view 的约束了
    func hasSetConstrainTo(view:UIView) -> Bool {
        for con in constraints {
            if con.to == view {
                assert(con.to.superview == con.from.superview, "A constraint.to and from must has same superview")
                return false
            }
        }
        return true
    }

    /// 确定了该 UIView.frame 后，装载 Constraint 至 to.ruler.section 中
    func setConstraintsFrom(view: UIView) {
        constraints.forEach { constraint in
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
                constraints.remove(constraint)
            }
        }
    }
    
}

// MARK: Assistant
private extension ConstraintManager {

    /// 按照程序逻辑，一个 view 最多同时只能在一个方向上拥有一个约束
    func removeDuplicateConstraintOf(view:UIView, at direction: Constraint.Direction) {
        constraints.forEach { con in
            if con.to == view && con.direction == direction {
                constraints.remove(con)
                return
            }
        }
    }
    
    class func checkCyclingConstraintWith(constraint:Constraint) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
            singleton.constraints.forEach { con in
                if con <=> constraint {
                    assert(false, "\n⚠️FangYuan: There is a constraint circulation between\n\(con.to)\n🔄\n\(con.from)\n")
                    return;
                }
            }
        }
    }
}

// TODO: 可是关于方向的问题你有没有想明白？

infix operator <=> {}
/// 判断两个约束是否产生了循环依赖

// TODO: 这个方法应该拆分的，也许是两个方向上的约束？那 LayoutWithFangYuan 是不是也需要拆分成两个方向上的？
func <=>(lhs: Constraint, rhs: Constraint) -> Bool {
    return lhs.to == rhs.from && lhs.from == rhs.to
}

func ==<V:UIView>(lhs: Weak<V>, rhs: Weak<V>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Weak<V:UIView>: Hashable {
    
    weak var view: V?
    
    init (_ view: V?) {
        self.view = view
    }
    
    var hashValue: Int {
        guard let view = view else {
            return 0
        }
        return view.hashValue
    }
}

typealias WeakView = Weak<UIView>
typealias ViewTree = [WeakView:[WeakView]]

extension UIView {
    var weak: Weak<UIView> {
        return Weak(self)
    }
}

//extension ConstraintManager {
//    
//    func managing(view:UIView) -> Bool {
//        return managingViews.contains(view.weak)
//    }
//    
//    func manage(view:UIView) {
//        managingViews.insert(view.weak)
//    }
//    
//    func cleanManagingViews() {
//        managingViews = Set(managingViews.filter {
//            $0.view != nil
//            })
//    }
//}

