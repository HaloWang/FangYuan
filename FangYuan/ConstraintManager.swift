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

    /// 单例
    static let singleton = ConstraintManager()
    private init() {}

    // TODO: Set vs Array (performance) ?
    // TODO: 看吧，到底用不用遍历全部约束？甚至从来没有一个 Constraint.hasSet -> false 的情况发生！
    // TODO: 可以把这个集合变成多叉树，以便更有针对性的进行 map/filter
    /// 全部约束
    var constraints = Set<Constraint>()
    
    class ConstraintHolder {
        var topBottom: Constraint?
        var bottomTop: Constraint?
        var leftRight: Constraint?
        var rightLeft: Constraint?
        
        func constraintAt(direction: Constraint.Direction) -> Constraint? {
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
        
        func set(constraint:Constraint?, at direction:Constraint.Direction) {
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
    }
    
    var holder = ConstraintHolder()

    /// 未设定约束相关信息
    var unsetConstraintInfo: (has: Bool, constraints: [Constraint]) {
        return (constraints.count != 0, Array(constraints))
    }
}

// MARK: - Public Methods
extension ConstraintManager {

    /**
     从某个视图得到约束
     
     - parameter from:      约束依赖视图
     - parameter direction: 约束方向
     */
    class func getConstraintFrom(from:UIView, direction: Constraint.Direction) {
        let newConstraint = Constraint(from: from, to: nil, direction: direction)
        singleton.holder.set(newConstraint, at: direction)
    }

    // TODO: setConstraint 是生成『渲染队列』的最佳时机了吧
    // TODO: 这个『渲染队列』还可以抽象成一个专门计算高度的类方法？
    // TODO: from.superview 和 to.superview 不同的话怎么办？可是这是后可能还没有 superview 呢？

    /**
     设定约束到某个视图上
     
     - parameter to:        约束目标
     - parameter direction: 约束方向
     - parameter value:     约束固定值
     */
    class func setConstraintTo(to:UIView, direction: Constraint.Direction, value:CGFloat) {
        
        //  如果对应方向上没有 holder，则认为 fy_XXX() 的参数中没有调用 chainXXX，直接返回，不进行后续操作
        guard let _constraint = singleton.holder.constraintAt(direction) else {
            return
        }
        
        singleton.removeInvalidConstraint()
        singleton.removeDuplicateConstraintOf(to, at: direction)
        singleton.removeAndWarningCyclingConstraint()

        _constraint.to = to
        _constraint.value = value

        singleton.constraints.insert(_constraint)
        singleton.holder.set(nil, at: direction)
    }

    class func layout(view:UIView) {

        let info = view.usingFangYuanInfo

        guard info.hasUsingFangYuanSubview else {
            return
        }

        singleton.layout(info.usingFangYuanSubviews)
    }
}

// MARK: - Private Methods

// MARK: Layout
private extension ConstraintManager {

    // TODO: 应该在这个方法中设置一个调试器
    // TODO: hasSetConstraintsOf 不是每次都要遍历的，可以提前生成一个渲染序列，这个渲染序列的副产品就是检查是否有依赖循环
    // TODO: 这个算法的复杂度是多少 views³constraint²
    // TODO: UITableView.addSubiew 后，调用 UITableView 的 layoutSubviews 并不会被触发？
    
    /// 核心布局方法
    func layout(views: [UIView]) {
        if hasUnsetConstraintsOf(views) {
            var layoutingViews = Set(views)
            repeat {
                print("✅ Layouting")
                _ = layoutingViews.map { view in
                    if hasSetConstraintsOf(view) {
                        view.layoutWithFangYuan()
                        setConstraintsOf(view)
                        layoutingViews.remove(view)
                    }
                }
            } while hasUnsetConstraintsOf(views)
        } else {
            _ = views.map { view in
                view.layoutWithFangYuan()
            }
        }
    }

    func hasUnsetConstraintsOf(views:[UIView]) -> Bool {

        let unsetInfo = unsetConstraintInfo

        guard unsetInfo.has else {
            return false
        }

        for view in views {
            for con in unsetInfo.constraints {
                if con.to == view {
                    return true
                }
            }
        }

        return false
    }

    func hasSetConstraintsOf(view:UIView) -> Bool {
        for con in constraints {
            if con.to == view {
                return false
            }
        }
        return true
    }

    func setConstraintsOf(view: UIView) {

        // 抽取所有需要设定的约束
        // TODO: 这才是关键所在！，每次你抽取的是全部约束
        let _constraintsShowP = constraints.filter { constraint in
            constraint.from == view
        }

        // 设定这些约束
        // TODO: 命名意义不明
        _ = _constraintsShowP.map { constraint in
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

// MARK: Assistant
private extension ConstraintManager {

    // TODO: 这里是不是可以用上 Set ?
    func removeDuplicateConstraintOf(view:UIView, at direction: Constraint.Direction) {
        _ = constraints.map { con in
            if con.to == view && con.direction == direction {
                constraints.remove(con)
            }
        }
    }

    // TODO: 时间复杂度？cons × cons ?
    func removeAndWarningCyclingConstraint() {
        for toCons in constraints {
            for fromCons in constraints {
                if toCons <=> fromCons {
                    constraints.remove(toCons)
                    constraints.remove(fromCons)
                    print("⚠️", "there is a cycling constraint")
                }
            }
        }
    }

    func removeInvalidConstraint() {
        let _constraints = constraints.filter { con in
            return con.to != nil && con.from != nil
        }
        constraints = Set(_constraints)
    }
}
