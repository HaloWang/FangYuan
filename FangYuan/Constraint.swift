//
//  Constraint.swift
//  FangYuan
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import UIKit

func ==(lhs: Constraint, rhs: Constraint) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

infix operator <=> {}
/// 判断两个约束是否产生了循环依赖

// TODO: 这个方法应该拆分的，也许是两个方向上的约束？那 LayoutWithFangYuan 是不是也需要拆分成两个方向上的？
func <=>(lhs: Constraint, rhs: Constraint) -> Bool {
    return lhs.to == rhs.from && lhs.from == rhs.to
}

/// 约束依赖
class Constraint: Hashable {

    let hashValue: Int

    /// 为满足 Constraint: Hashable，每次 Constraint.init 执行后，hashStore 值会 +1
    static var hashStore = 0

    /// 约束来源于那个视图
    weak var from: UIView!

    /// 约束为谁设定
    weak var to: UIView!

    /// 约束方向
    var direction: Direction

    /// 该约束的数字量
    var value: CGFloat = 0

    /// 约束方向
    enum Direction {
        case BottomTop
        case LeftRigt
        case RightLeft
        case TopBottom
        
        var horizontal : Bool {
            return self == Constraint.Direction.LeftRigt || self == Constraint.Direction.RightLeft
        }
    }
    
    /**
     初始化方法
     
     - parameter from:      该约束需要等待 from 布局完成后才能是有效的
     - parameter to:        from 布局完成后，to会开始根据这个约束来布局
     - parameter direction: 约束方向
     - parameter value:     该约束的固定值，默认为 0
     */
    init(from: UIView?, to: UIView?, direction: Constraint.Direction, value: CGFloat = 0) {
        self.hashValue = Constraint.hashStore
        self.from = from
        self.to = to
        self.direction = direction
        self.value = value
        Constraint.checkAndUpdateHashStore()
    }
    
    // TODO: thread safe ?
    class func checkAndUpdateHashStore() {
        if hashStore == Int.max {
            hashStore = 0
        }
        hashStore += 1
    }
    
    /// 在 cons 中的 con 变了的话，都有哪些 _cons 需要重设？
    class func _dev_checkDeps(con:Constraint, cons:Set<Constraint>) {
        cons.forEach {
            $0
        }
    }
    
    /// 在 inCons 中的 cons 变了的话，都有哪些 _cons 需要重设？
    class func _dev_checkDeps(cons:Set<Constraint>, inCons:Set<Constraint>) {
        cons.forEach {
            $0
        }
    }
}

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

///
/// - Note: 我就是想面对同样的数据结构的时候不用再写一遍寻址方法了
/// - TODO: Protocol 'Hashable' can only be used as a generic constraint because it has Self or associated type requirements. WTF?
///
protocol FangYuanIndexAble {
    var to : UIView { get }
    var from : UIView { get }
}

extension FangYuanIndexAble {
    
}

extension SequenceType {
    
}

extension Constraint: CustomStringConvertible {
    var description: String {
        return "\nConstraint:\n✅direction: \(direction) \n⏬from: \(from) \n⏫to: \(to)\nℹ️Value: \(value)"
    }
}
