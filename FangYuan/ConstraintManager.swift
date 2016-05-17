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
        
        //  如果对应方向上没有 holder，则认为 fy_XXX() 的参数中没有调用 chainXXX，直接返回，不进行后续操作
        guard let _constraint = singleton.holder.popConstraintAt(direction) else {
            return
        }
        
        singleton.removeDuplicateConstraintOf(to, at: direction)
        _constraint.to = to
        _constraint.value = value
        singleton.checkCyclingConstraintWith(_constraint)
        singleton.constraints.insert(_constraint)
        singleton.holder.clearConstraintAt(direction)
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

    // TODO: UITableView.addSubiew 后，调用 UITableView 的 layoutSubviews 并不会被触发？
    // TODO: ⚠️ 你这个计算模型真的合理吗？根据 Model 动态设定 fy_() 的时候，能保证不产生问题吗？
    // TODO: 1、做更复杂的 UITableViewCell 验证一下
    // TODO: 2、把布局模型再思考一遍
    
    /// 核心布局方法
    func layout(views: [UIView]) {
        
        guard hasUnsetConstraintsOf(views) else {
            views.forEach { view in
                view.layoutWithFangYuan()
            }
            return
        }
        
        var layoutingViews = Set(views)
        //  未设定的约束中，发现有用来约束 view 的约束
        var shouldRepeat : Bool
        repeat {
            shouldRepeat = false
            layoutingViews.forEach { view in
                if hasSetConstrainTo(view) {
                    view.layoutWithFangYuan()
                    setConstraintsFrom(view)
                    //  在被遍历的数组中移除该 view
                    layoutingViews.remove(view)
                } else {
                    shouldRepeat = true
                }
            }
        } while shouldRepeat
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
    
    // TODO: 这个方法还没有被测试过
    func checkCyclingConstraintWith(constraint:Constraint) {
        constraints.forEach { con in
            if con <=> constraint {
                assert(false, "there is a cycling constraint between view:\(con.to) and view:\(con.from)")
                return;
            }
        }
    }
}
