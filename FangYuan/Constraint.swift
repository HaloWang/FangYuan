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

// TODO: 这个方法应该拆分的，也许是两个区间上的约束？那 LayoutWithFangYuan 是不是也需要拆分成两个区间上的？
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

    /// 约束区间
    var section: Section

    /// 该约束的数字量
    var value: CGFloat = 0

    /// 约束区间
    enum Section {
        case Left
        case Right
        case Top
        case Bottom
        
        var horizontal : Bool {
            return self == Constraint.Section.Right || self == Constraint.Section.Left
        }
    }
    
    /**
     初始化方法
     
     - parameter from:      该约束需要等待 from 布局完成后才能是有效的
     - parameter to:        from 布局完成后，to会开始根据这个约束来布局
     - parameter section:   约束区间
     - parameter value:     该约束的固定值，默认为 0
     */
    init(from: UIView?, to: UIView?, section: Constraint.Section, value: CGFloat = 0) {
        self.hashValue = Constraint.hashStore
        self.from = from
        self.to = to
        self.section = section
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
}

class ConstraintHolder {
    var topBottom: Constraint?
    var bottomTop: Constraint?
    var leftRight: Constraint?
    var rightLeft: Constraint?
    
    func popConstraintAt(section: Constraint.Section) -> Constraint? {
        switch section {
        case .Bottom:
            return topBottom
        case .Top:
            return bottomTop
        case .Right:
            return leftRight
        case .Left:
            return rightLeft
        }
    }
    
    func push(constraint:Constraint?, at section:Constraint.Section) {
        switch section {
        case .Bottom:
            topBottom = constraint
        case .Top:
            bottomTop = constraint
        case .Right:
            leftRight = constraint
        case .Left:
            rightLeft = constraint
        }
    }
    
    func clearConstraintAt(section: Constraint.Section) {
        push(nil, at: section)
    }
}

extension Constraint: CustomStringConvertible {
    var description: String {
        return "\nConstraint:\n✅section: \(section) \n⏬from: \(from) \n⏫to: \(to)\nℹ️Value: \(value)"
    }
}
