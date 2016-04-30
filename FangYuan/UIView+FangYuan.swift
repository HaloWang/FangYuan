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
        DependencyManager.sharedManager.push(self, to: nil, direction: .LeftRigt)
        return 0
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        DependencyManager.sharedManager.push(self, to: nil, direction: .RightLeft)
        return 0
    }

    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        DependencyManager.sharedManager.push(self, to: nil, direction: .BottomTop)
        return 0
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        DependencyManager.sharedManager.push(self, to: nil, direction: .TopBottom)
        return 0
    }
}

// MARK: - Chainable Method


public extension UIView {

    // MARK: X

    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    func fy_left(left: CGFloat) -> Self {
        usingFangYuan = true
        fy_left = left
        DependencyManager.sharedManager.pop(nil, to: self, direction: .RightLeft, value: left)
        return self
    }

    /// 设定某个 UIView 的宽度，相当于 width
    func fy_width(width: CGFloat) -> Self {
        usingFangYuan = true
        fy_width = width
        return self
    }

    /// 设定某个 UIView 右边距离其 superview 右边的距离
    func fy_right(right: CGFloat) -> Self {
        usingFangYuan = true
        fy_right = right
        DependencyManager.sharedManager.pop(nil, to: self, direction: .LeftRigt, value: right)
        return self
    }

    // MARK: Y

    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        usingFangYuan = true
        fy_top = top
        DependencyManager.sharedManager.pop(nil, to: self, direction: .BottomTop, value: top)
        return self
    }

    /// 设定某个 UIView 的高度，相当于 height
    func fy_height(height: CGFloat) -> Self {
        usingFangYuan = true
        fy_height = height
        return self
    }

    /// 设定某个 UIView 底部距离其 superview 底部的距离
    func fy_bottom(bottom: CGFloat) -> Self {
        usingFangYuan = true
        fy_bottom = bottom
        DependencyManager.sharedManager.pop(nil, to: self, direction: .TopBottom, value: bottom)
        return self
    }

    // MARK: Edge

    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        fy_top(edge.top).fy_bottom(edge.bottom).fy_left(edge.left).fy_right(edge.right)
        return self
    }
}

// MARK: - _privte Associated Object

// TODO: 或许方圆可以变成一个协议？FangAble？😁然后为 CALayer 提供？PS: 主要是觉得这个文件所含有的内容越来越少了

internal extension UIView {

    // TODO: 这里也可以做成 JSPatch 那样，使用某个 object 作为 <##>

    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/

    private struct AssociatedKeys {
        static var RulerX: Any?
        static var RulerY: Any?
        static var kUsingFangYuan: Any?
    }

    /// X 轴标尺
    var rulerX: Ruler {
        //  终于不用写两次 `objc_getAssociatedObject` 啦：😁 @see UIView+WebCacheOperation.m
        if let ruler = objc_getAssociatedObject(self, &AssociatedKeys.RulerX) {
            return ruler as! Ruler
        }
        let ruler = Ruler()
        objc_setAssociatedObject(self, &AssociatedKeys.RulerX, ruler, .OBJC_ASSOCIATION_RETAIN)
        return ruler
    }

    /// Y 轴表尺
    var rulerY: Ruler {
        if let ruler = objc_getAssociatedObject(self, &AssociatedKeys.RulerY) {
            return ruler as! Ruler
        }
        let ruler = Ruler()
        objc_setAssociatedObject(self, &AssociatedKeys.RulerY, ruler, .OBJC_ASSOCIATION_RETAIN)
        return ruler
    }

    /// 该 View 是否在使用 FangYuan
    var usingFangYuan: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kUsingFangYuan) != nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kUsingFangYuan, newValue ? "" : nil, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}

// MARK: - _private Computed Properties

// TODO: 也许可以作为将来 FangYuanAble 的协议？

internal extension UIView {

    // MARK: X

    var fy_left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            rulerX.a = newValue
        }
    }

    var fy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            rulerX.b = newValue
        }
    }

    var fy_right: CGFloat {
        get {
            return superview!.fy_width - chainRight
        }
        set {
            rulerX.c = newValue
        }
    }

    // MARK: Y

    var fy_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            rulerY.a = newValue
        }
    }

    var fy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            rulerY.b = newValue
        }
    }

    var fy_bottom: CGFloat {
        get {
            return superview!.fy_height - chainBottom
        }
        set {
            rulerY.c = newValue
        }
    }

}
