//
//  Dependency.swift
//  Pods
//
//  Created by 王策 on 16/4/26.
//
//

import UIKit

/// 约束依赖
class Dependency {

    /// 约束来源于那个视图
    weak var from: UIView!

    /// 约束为谁设定
    weak var to: UIView!

    /// 约束方向
    var direction: Direction

    /// 该约束的数字常量
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

    init(from: UIView?, to: UIView?, direction: Dependency.Direction, value: CGFloat = 0) {
        self.from = from
        self.to = to
        self.direction = direction
        self.value = value
    }
}

extension Dependency : CustomStringConvertible {
    var description: String {
        return "\nDependency:\n✅direction: \(direction) \n⏬from: \(from) \n⏫to: \(to)\nℹ️Value: \(value)\nℹ️Setted: \(hasSet)"
    }
}
