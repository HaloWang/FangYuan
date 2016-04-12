//
//  UIView+FangYuan.swift
//  Halo
//
//  Created by 王策 on 15/11/12.
//  Copyright © 2015年 WangCe. All rights reserved.
//

import UIKit

// MARK: - Chainable Getter

public extension UIView {
    
    // TODO: 添加依赖
    internal func addDep(@noescape block:()->Void) {
        block()
    }

    /// 描述某个 **view 右边** 距该 **view 左边**的关系时，使用该属性：
    ///
    /// someView.fy_right(self.chainLeft)
    var chainLeft: CGFloat {
        Manager.sharedManager.push(.LeftRigt, fromView: self)
        return superview == nil ? 0 : superview!.fy_width - fy_left
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        Manager.sharedManager.push(.RightLeft, fromView: self)
        return fy_left + fy_width
    }

    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        Manager.sharedManager.push(.BottomTop, fromView: self)
        return fy_top + fy_height
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        Manager.sharedManager.push(.TopBottom, fromView: self)
        return superview == nil ? 0 : superview!.fy_height - fy_top
    }
}

// MARK: - Chainable Method


public extension UIView {

    internal func tellUsingFangYuan(@noescape block: () -> Void) {
        
        usingFangYuan = true
        
        if Manager.sharedManager.canPop {
            Manager.sharedManager.pop(toView: self)
        }
        
        block()
    }
    
    // MARK: X

    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    func fy_left(left: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_left = left
        }
        return self
    }

    /// 设定某个 UIView 的宽度，相当于 width
    func fy_width(width: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_width = width
        }
        return self
    }

    /// 设定某个 UIView 右边距离其 superview 右边的距离
    func fy_right(right: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_right = right
        }
        return self
    }

    // MARK: Y

    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_top = top
        }
        return self
    }

    /// 设定某个 UIView 的高度，相当于 height
    func fy_height(height: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_height = height
        }
        return self
    }

    /// 设定某个 UIView 底部距离其 superview 底部的距离
    func fy_bottom(bottom: CGFloat) -> Self {
        tellUsingFangYuan {
            self.fy_bottom = bottom
        }
        return self
    }

    // MARK: Edge

    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        tellUsingFangYuan {
            self.fy_top = edge.top
            self.fy_bottom = edge.bottom
            self.fy_left = edge.left
            self.fy_right = edge.right
        }
        return self
    }
}
