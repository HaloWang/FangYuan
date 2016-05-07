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

    /// 描述某个 **view 右边** 距该 **view 左边**的关系时，使用该属性：
    ///
    /// someView.fy_right(self.chainLeft)
    var chainLeft: CGFloat {
        DependencyManager.getDependencyFrom(self, direction: .LeftRigt)
        return 0
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        DependencyManager.getDependencyFrom(self, direction: .RightLeft)
        return 0
    }

    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        DependencyManager.getDependencyFrom(self, direction: .BottomTop)
        return 0
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        DependencyManager.getDependencyFrom(self, direction: .TopBottom)
        return 0
    }
}

// MARK: - Chainable Method

public extension UIView {

    // TODO: 还有一个严重的问题：『变化』

    // MARK: X

    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    func fy_left(left: CGFloat) -> Self {
        usingFangYuan = true
        rulerX.a = left
        DependencyManager.setDependencyTo(self, direction: .RightLeft, value: left)
        return self
    }

    /// 设定某个 UIView 的宽度，相当于 width
    func fy_width(width: CGFloat) -> Self {
        usingFangYuan = true
        rulerX.b = width
        return self
    }

    /// 设定某个 UIView 右边距离其 superview 右边的距离
    func fy_right(right: CGFloat) -> Self {
        usingFangYuan = true
        rulerX.c = right
        DependencyManager.setDependencyTo(self, direction: .LeftRigt, value: right)
        return self
    }

    // MARK: Y

    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        usingFangYuan = true
        rulerY.a = top
        DependencyManager.setDependencyTo(self, direction: .BottomTop, value: top)
        return self
    }

    /// 设定某个 UIView 的高度，相当于 height
    func fy_height(height: CGFloat) -> Self {
        usingFangYuan = true
        rulerY.b = height
        return self
    }

    /// 设定某个 UIView 底部距离其 superview 底部的距离
    func fy_bottom(bottom: CGFloat) -> Self {
        usingFangYuan = true
        rulerY.c = bottom
        DependencyManager.setDependencyTo(self, direction: .TopBottom, value: bottom)
        return self
    }

    // MARK: Edge

    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        return fy_top(edge.top).fy_bottom(edge.bottom).fy_left(edge.left).fy_right(edge.right)
    }

    // MARK: Animation

    /// 触发动画
    func toAnimation() {
        DependencyManager.layout(self)
    }
}
