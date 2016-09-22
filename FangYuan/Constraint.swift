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
        case left
        case right
        case top
        case bottom
        
        var horizontal : Bool {
            return self == Constraint.Section.right || self == Constraint.Section.left
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
    
    /// - Todo: thread safe ?
    class func checkAndUpdateHashStore() {
        if hashStore == Int.max {
            hashStore = 0
        }
        hashStore += 1
    }
}

class ConstraintHolder {
    var bottom: Constraint?
    var top: Constraint?
    var right: Constraint?
    var left: Constraint?
    
    func constraintAt(_ section: Constraint.Section) -> Constraint? {
        switch section {
        case .bottom:
            return bottom
        case .top:
            return top
        case .right:
            return right
        case .left:
            return left
        }
    }
    
    func set(_ constraint:Constraint?, at section:Constraint.Section) {
        switch section {
        case .bottom:
            bottom = constraint
        case .top:
            top = constraint
        case .right:
            right = constraint
        case .left:
            left = constraint
        }
    }
    
    func clearConstraintAt(_ section: Constraint.Section) {
        set(nil, at: section)
    }
}

extension Constraint: CustomStringConvertible {
    var description: String {
        return "\nConstraint:\n✅section: \(section) \n⏬from: \(from) \n⏫to: \(to)\nℹ️Value: \(value)"
    }
}
