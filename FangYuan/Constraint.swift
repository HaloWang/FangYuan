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

/// 约束依赖
class Constraint: Hashable {

    let hashValue: Int

    static var ConstraintHash = 0

    /// 约束来源于那个视图
    weak var from: UIView!

    /// 约束为谁设定
    weak var to: UIView!

    /// 约束方向
    var direction: Direction

    /// 该约束的数字量
    var value: CGFloat = 0

    /// 该约束在当前 layoutSubviews 方法中是否已经求解完毕
    var hasSet = false

    /// 约束方向
    enum Direction {
        case BottomTop
        case LeftRigt
        case RightLeft
        case TopBottom
    }

    init(from: UIView?, to: UIView?, direction: Constraint.Direction, value: CGFloat = 0) {
        Constraint.ConstraintHash += 1
        self.hashValue = Constraint.ConstraintHash
        self.from = from
        self.to = to
        self.direction = direction
        self.value = value
    }
}

extension Constraint: CustomStringConvertible {
    var description: String {
        return "\nConstraint:\n✅direction: \(direction) \n⏬from: \(from) \n⏫to: \(to)\nℹ️Value: \(value)\nℹ️Setted: \(hasSet)"
    }
}
