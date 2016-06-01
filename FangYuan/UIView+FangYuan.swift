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
        ConstraintManager.pushConstraintFrom(self, direction: .LeftRigt)
        return 0
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        ConstraintManager.pushConstraintFrom(self, direction: .RightLeft)
        return 0
    }

    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        ConstraintManager.pushConstraintFrom(self, direction: .BottomTop)
        return 0
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        ConstraintManager.pushConstraintFrom(self, direction: .TopBottom)
        return 0
    }
}

// MARK: - Chainable Method

// TODO: 如何在调用完下面的方法后让 superview 刷新？

public extension UIView {
    
    // MARK: X
    
    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    func fy_left(left: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        popConstraintAt(.RightLeft, value: left)
        return self
    }
    
    /// 设定某个 UIView 的宽度，相当于 width
    func fy_width(width: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        rulerX.b = width
        return self
    }
    
    /// 设定某个 UIView 右边距离其 superview 右边的距离
    func fy_right(right: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        popConstraintAt(.LeftRigt, value: right)
        return self
    }
    
    // MARK: Y
    
    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        popConstraintAt(.BottomTop, value: top)
        return self
    }
    
    /// 设定某个 UIView 的高度，相当于 height
    func fy_height(height: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(false)
        rulerY.b = height
        return self
    }
    
    /// 设定某个 UIView 底部距离其 superview 底部的距离
    func fy_bottom(bottom: CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(false)
        popConstraintAt(.TopBottom, value: bottom)
        return self
    }
    
    // MARK: Edge
    
    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        resetRelatedConstraintHorizontal(false)
        popConstraintAt(.BottomTop, value: edge.top)
        popConstraintAt(.TopBottom, value: edge.bottom)
        popConstraintAt(.RightLeft, value: edge.left)
        popConstraintAt(.LeftRigt, value: edge.right)
        return self
    }
    
    func fy_xRange(left:CGFloat, right:CGFloat) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        popConstraintAt(.RightLeft, value: left)
        popConstraintAt(.LeftRigt, value: right)
        return self
    }
    
    func fy_size(size:CGSize) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        resetRelatedConstraintHorizontal(false)
        rulerX.b = size.width
        rulerY.b = size.height
        return self
    }
    
    func fy_origin(origin:CGPoint) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        resetRelatedConstraintHorizontal(false)
        popConstraintAt(.BottomTop, value: origin.y)
        popConstraintAt(.RightLeft, value: origin.x)
        return self
    }
    
    func fy_frame(frame:CGRect) -> Self {
        basicSetting()
        resetRelatedConstraintHorizontal(true)
        resetRelatedConstraintHorizontal(false)
        popConstraintAt(.BottomTop, value: frame.origin.y)
        popConstraintAt(.RightLeft, value: frame.origin.x)
        fy_size(frame.size)
        return self
    }
    
    // MARK: Animation

    /// 触发动画
    ///
    /// 只有当 view.superview 不为空时，该方法才有效
    func toAnimation() {
        
        // TODO: 这个方法还有更好的写法吗？
        
        guard let superview = superview else {
            return
        }
        ConstraintManager.layout(superview)
    }
}
