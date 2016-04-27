//
//  Dependency.swift
//  Pods
//
//  Created by 王策 on 16/4/26.
//
//

import Foundation

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

    /// 调用 Chain 方法时，使用该方法初始化一个约束
    init(from: UIView, direction: Dependency.Direction) {
        self.from = from
        self.direction = direction
    }
}

extension Dependency : CustomStringConvertible {
    var description: String {
        return "\nDependency:\n✅direction: \(direction) \n⏬from: \(from) \n⏫to: \(to)\n"
    }
}
