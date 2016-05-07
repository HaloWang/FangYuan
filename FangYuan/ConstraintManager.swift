//
//  ConstraintManager.swift
//  Halo
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

    /// 刚刚压入的约束
    var constraintHolder: Constraint?

    /// 未设定约束相关信息
    var unsetConstraintInfo: (has: Bool, constraints: [Constraint]) {
        let unsetCons = constraints.filter { con in
            !con.hasSet
        }
        return (unsetCons.count != 0, unsetCons)
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
        singleton.constraintHolder = Constraint(from: from, to: nil, direction: direction)
    }

    // TODO: setConstraint 是生成『渲染队列』的最佳时机了吧
    // TODO: 这个『渲染队列』还可以抽象成一个专门计算高度的类方法？

    /**
     设定约束到某个视图上
     
     - parameter to:        约束目标
     - parameter direction: 约束方向
     - parameter value:     约束固定值
     */
    class func setConstraintTo(to:UIView, direction: Constraint.Direction, value:CGFloat) {
        singleton.removeInvalidConstraint()
        singleton.removeDuplicateConstraintOf(to, at: direction)
        // TODO: 未实现
        singleton.removeAndWarningCyclingConstraint()
        guard let holder = singleton.constraintHolder else {
            return
        }

        holder.to = to
        holder.value = value

        singleton.constraints.insert(holder)
        singleton.constraintHolder = nil
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

    // TODO: hasSetconstraintsOf 不是每次都要遍历的，可以提前生成一个渲染序列，这个渲染序列的副产品就是检查是否有依赖循环
    // TODO: 这个算法的复杂度是多少
    /// 核心布局方法
    func layout(views: [UIView]) {
        if hasUnsetConstraintsOf(views) {
            var layoutingViews = Set(views)
            repeat {
                _ = layoutingViews.map { view in
                    if hasSetconstraintsOf(view) {
                        view.layoutWithFangYuan()
                        setconstraintsOf(view)
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

    func hasSetconstraintsOf(view:UIView) -> Bool {
        for con in constraints {
            if con.to == view && !con.hasSet {
                return false;
            }
        }
        return true
    }

    func setconstraintsOf(view: UIView) {

        // 抽取所有需要设定的约束
        // TODO: 这才是关键所在！，每次你抽取的是全部约束
        let _constraintsShowP = constraints.filter { constraint in
            constraint.from == view
        }

        // 设定这些约束
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
            constraint.hasSet = true
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
    // TODO: 布局实际上也像 node.js 那样是一个高并发的东西？
    func removeAndWarningCyclingConstraint() {

    }

    func removeInvalidConstraint() {
        let _constraints = constraints.filter { con in
            return con.to != nil && con.from != nil
        }
        constraints = Set(_constraints)
    }
}
