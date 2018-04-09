//
//  UIView+FangYuan.swift
//  FangYuan
//
//  Created by 王策 on 15/11/12.
//  Copyright © 2015年 WangCe. All rights reserved.
//

import UIKit

// MARK: - Chainable Getter

public extension UIView {
    
    /// 描述某个 **view 右边** 距该 **view 左边**的关系时，使用该属性：
    ///
    /// someView.fy_right(self.chainLeft)
    var chainLeft: CGFloat {
        _fy_layoutQueue {
            ConstraintManager.pushConstraintFrom(self, section: .right)
        }
        return 0
    }
    
    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        _fy_layoutQueue {
            ConstraintManager.pushConstraintFrom(self, section: .left)
        }
        return 0
    }
    
    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        _fy_layoutQueue {
            ConstraintManager.pushConstraintFrom(self, section: .top)
        }
        return 0
    }
    
    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        _fy_layoutQueue {
            ConstraintManager.pushConstraintFrom(self, section: .bottom)
        }
        return 0
    }
}

// MARK: - Chainable Method

/// - Todo: 真的可以开一个线程，把大运算量的操作都扔到后台去，layoutSubviews 的时候在等待一下，但是得补一下『等待某个值为 true 才执行』这种需求了吧

/// - Todo: 如何在调用完下面的方法后让 superview 刷新？

public extension UIView {
    
    // MARK: X
    
    /// Set a UIView left distance from it's superview, just like setting of `UIView.frame.origin.x`
    ///
    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    ///
    /// ### <font>✅ Vaild Usage:</font>
    /// - `view.fy_left(15)`
    /// - `viewA.fy_left(viewB.chainRight)`
    /// - `viewA.fy_left(viewB.chainRight + 15)`
    /// ### <font>❌ Invalid Usage:</font>
    /// - `viewA.fy_left(viewA.chainRight)`
    /// - `viewA.fy_left(viewB.chainTop)`
    /// - `viewA.fy_left(viewB.chainRight * 2)`
    /// - `viewA.fy_left(viewB.chainRight + viewB.chainLeft)`
    /// - `viewA.fy_left(viewB.chainRight + viewC.chainRight)`
    @discardableResult
    func fy_left(_ left: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.popConstraintAt(.left, value: left)
        }
        return self
    }
    
    /// 设定某个 UIView 的宽度，相当于 width
    @discardableResult
    func fy_width(_ width: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.rulerX.b = width
        }
        return self
    }
    
    /// 设定某个 UIView 右边距离其 superview 右边的距离
    @discardableResult
    func fy_right(_ right: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.popConstraintAt(.right, value: right)
        }
        return self
    }
    
    // MARK: Y
    
    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    @discardableResult
    func fy_top(_ top: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.popConstraintAt(.top, value: top)
        }
        return self
    }
    
    /// 设定某个 UIView 的高度，相当于 height
    @discardableResult
    func fy_height(_ height: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(false)
            self.rulerY.b = height
        }
        return self
    }
    
    /// 设定某个 UIView 底部距离其 superview 底部的距离
    @discardableResult
    func fy_bottom(_ bottom: CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(false)
            self.popConstraintAt(.bottom, value: bottom)
        }
        return self
    }
    
    // MARK: Edge
    
    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    @discardableResult
    func fy_edge(_ edge: UIEdgeInsets) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.resetRelatedConstraintHorizontal(false)
            self.popConstraintAt(.top, value: edge.top)
            self.popConstraintAt(.bottom, value: edge.bottom)
            self.popConstraintAt(.left, value: edge.left)
            self.popConstraintAt(.right, value: edge.right)
        }
        return self
    }
    
    @discardableResult
    func fy_xRange(_ left:CGFloat, _ right:CGFloat) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.popConstraintAt(.left, value: left)
            self.popConstraintAt(.right, value: right)
        }
        return self
    }
    
    @discardableResult
    func fy_size(_ size:CGSize) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.resetRelatedConstraintHorizontal(false)
            self.rulerX.b = size.width
            self.rulerY.b = size.height
        }
        return self
    }
    
    @discardableResult
    func fy_origin(_ origin:CGPoint) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.resetRelatedConstraintHorizontal(false)
            self.popConstraintAt(.top, value: origin.y)
            self.popConstraintAt(.left, value: origin.x)
        }
        return self
    }
    
    @discardableResult
    func fy_frame(_ frame:CGRect) -> Self {
        basicSetting {
            self.resetRelatedConstraintHorizontal(true)
            self.resetRelatedConstraintHorizontal(false)
            self.popConstraintAt(.top, value: frame.origin.y)
            self.popConstraintAt(.left, value: frame.origin.x)
            self.rulerX.b = frame.size.width
            self.rulerY.b = frame.size.height
        }
        return self
    }
    
    /// - Todo: Unfinish
    fileprivate func fy_centerX(_ adjust:CGFloat) -> Self {
        basicSetting {
            
        }
        return self
    }
    
    /// - Todo: Unfinish
    fileprivate func fy_centerY(_ adjust:CGFloat) -> Self {
        basicSetting { 
            
        }
        return self
    }
    
    // MARK: Animation
    
    /// 触发动画
    ///
    /// 只有当 view.superview 不为空时，该方法才有效
    func fy_animate() {
        guard let superview = superview else {
            return
        }
        ConstraintManager.layout(superview)
    }
}
