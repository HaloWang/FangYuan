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
        DependencyManager.pushDependencyFrom(self, direction: .LeftRigt)
        return 0
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        DependencyManager.pushDependencyFrom(self, direction: .RightLeft)
        return 0
    }

    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        DependencyManager.pushDependencyFrom(self, direction: .BottomTop)
        return 0
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        DependencyManager.pushDependencyFrom(self, direction: .TopBottom)
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
        DependencyManager.popDependencyTo(self, direction: .RightLeft, value: left)
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
        DependencyManager.popDependencyTo(self, direction: .LeftRigt, value: right)
        return self
    }

    // MARK: Y

    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        usingFangYuan = true
        rulerY.a = top
        DependencyManager.popDependencyTo(self, direction: .BottomTop, value: top)
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
        DependencyManager.popDependencyTo(self, direction: .TopBottom, value: bottom)
        return self
    }

    // MARK: Edge

    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        fy_top(edge.top).fy_bottom(edge.bottom).fy_left(edge.left).fy_right(edge.right)
        return self
    }
    
    // MARK: Animation
    
    /// 触发动画
    func toAnimation() {
        DependencyManager.layout(self)
    }
}

// MARK: - Associated Object

// TODO: 或许方圆可以变成一个协议？FangYuanAble？然后为 CALayer 提供？

extension UIView {

    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/

    struct AssociatedKeys {
        static var RulerX: Any?
        static var RulerY: Any?
        static var kUsingFangYuan: Any?
        static var AO : Any?
    }
    
    class AssociateObject {
        lazy var rulerX = Ruler()
        lazy var rulerY = Ruler()
        var usingFangYuan = false
    }
    
    var ao : AssociateObject {
        if let _ao = objc_getAssociatedObject(self, &AssociatedKeys.AO) {
            return _ao as! AssociateObject
        }
        let _ao = AssociateObject()
        objc_setAssociatedObject(self, &AssociatedKeys.AO, _ao, .OBJC_ASSOCIATION_RETAIN)
        return _ao
    }

    /// X 轴标尺
    var rulerX: Ruler {
        return ao.rulerX
    }

    /// Y 轴表尺
    var rulerY: Ruler {
        return ao.rulerY
    }
    
    /// 该 View 是否在使用 FangYuan
    var usingFangYuan: Bool {
        get {
            return ao.usingFangYuan
        }
        set {
            ao.usingFangYuan = newValue
        }
    }
}


// MARK: - Using FangYuan
extension UIView {
    
    struct once {
        static var token: dispatch_once_t = 0
    }
    
    // We can not override +load in Swift
    override public class func initialize() {
        dispatch_once(&once.token) {
            _swizzle_layoutSubviews()
        }
    }
    
    /// 交换实现
    class func _swizzle_layoutSubviews() {
        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(_swizzle_imp_for_layoutSubviews)
        let originalMethod   = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    func _swizzle_imp_for_layoutSubviews() {
        _swizzle_imp_for_layoutSubviews()
        DependencyManager.layout(self)
    }
    
    var usingFangYuanInfo : (subviewUsingFangYuan: Bool, usingFangYuanSubviews: [UIView]) {
        let _usingFangYuanSubviews = subviews.filter { (subview) -> Bool in
            return subview.usingFangYuan
        }
        return (_usingFangYuanSubviews.count != 0, _usingFangYuanSubviews)
    }

    // TODO: 这个算法还是应该被 UT 一下
    // TODO: 大量的 if (!=) = 会不会有问题？
    /// 在约束已经求解完全的情况下进行 frame 的设置
    func layoutWithFangYuan() {

        //  X
        let newX = rulerX.a
        if newX != nil {
            if frame.origin.x != newX {
                frame.origin.x = newX
            }
            let newWidth = rulerX.b ?? superview!.frame.width - newX - rulerX.c
            if frame.size.width != newWidth {
                frame.size.width = newWidth
            }
        } else {
            let newX = superview!.frame.width - rulerX.b - rulerX.c
            if frame.origin.x != newX {
                frame.origin.x = newX
            }
            let newWidth = rulerX.b
            if frame.width != newWidth {
                frame.size.width = newWidth
            }
        }

        //  Y
        let newY = rulerY.a
        if newY != nil {
            if frame.origin.y != newY {
                frame.origin.y = newY
            }
            let newHeight = rulerY.b ?? superview!.frame.height - newY - rulerY.c
            if frame.height != newHeight {
                frame.size.height = newHeight
            }
        } else {
            let newY = superview!.frame.height - rulerY.b - rulerY.c
            if frame.origin.y != newY {
                frame.origin.y = newY
            }
            let newHeight = rulerY.b
            if frame.height != newHeight {
                frame.size.height = newHeight
            }
        }
    }
}

extension UIButton {
    
    struct uibutton_once {
        static var token: dispatch_once_t = 0
    }
    
    override public class func initialize() {
        dispatch_once(&uibutton_once.token) {
            _swizzle_layoutSubviews()
        }
    }
    
    override class func _swizzle_layoutSubviews() {
        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(_swizzle_imp_for_layoutSubviews)
        let originalMethod   = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    override func _swizzle_imp_for_layoutSubviews() {
        _swizzle_imp_for_layoutSubviews()
        DependencyManager.layout(self)
    }
}
