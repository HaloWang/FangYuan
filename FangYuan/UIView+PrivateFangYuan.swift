//
//  UIView+PrivateFangYuan.swift
//  FangYuan
//
//  Created by 王策 on 16/5/7.
//  Copyright © 2015年 WangCe. All rights reserved.
//

import Foundation

// MARK: - Using FangYuan

extension UIView {

    // TODO: 能不能让 ConstraintManager 记录 usingFangYuan 的信息？
    // TODO: 这个属性还是非常值得优化一下的！可是如何制作一个弱引用数组呢？
    // TODO: 所有的 UIView 都会被加上一个关联对象，并且每次调用 getter, 简直不能忍！
    // TODO: 应该简化这个属性了
    // TODO: 并发遍历可能真的是个很重要的属性
    
    /// 该 UIView.subviews 使用方圆的信息，通过一次 filter 和元组返回了是否在使用方圆和使用方圆的 subview
    var usingFangYuanInfo: (hasUsingFangYuanSubview:Bool, usingFangYuanSubviews:[UIView]) {
        let _usingFangYuanSubviews = subviews.filter {
            (subview) -> Bool in
            return subview.usingFangYuan
        }
        return (_usingFangYuanSubviews.count != 0, _usingFangYuanSubviews)
    }

    /// 在约束已经求解完全的情况下进行 frame 的设置
    func layoutWithFangYuan() {
        
        // TODO: 能不能输出中文 assert 呢？
        assert(rulerX.full, "⚠️FangYuan:\n\(self) \nUIView.RulerX is not fully defined!\n")
        assert(rulerY.full, "⚠️FangYuan:\n\(self) \nUIView.RulerY is not fully defined!\n")
        
        guard rulerX.full && rulerY.full else {
            return
        }

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

// MARK: - Associated Object

extension UIView {

    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/

    struct AssociatedKeys {
        static var AO: Any?
    }

    class AssociateObject {
        lazy var rulerX = Ruler()
        lazy var rulerY = Ruler()
        var usingFangYuan = false
    }

    var ao: AssociateObject {
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

// MARK: - UIView Swizzling

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
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    func _swizzle_imp_for_layoutSubviews() {
        _swizzle_imp_for_layoutSubviews()
        ConstraintManager.layout(self)
    }

}

// MARK: - UIButton Swizzling

extension UIButton {

    struct uibutton_once {
        static var token: dispatch_once_t = 0
    }

    override public class func initialize() {
        dispatch_once(&uibutton_once.token) {
            _swizzle_layoutSubviews()
        }
    }
    
    //  If following method is not implemented
    //  -[_UINavigationBarBackground state]: unrecognized selector sent to instance 0x137e804d0
    //  Interesting!

    override class func _swizzle_layoutSubviews() {
        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(_swizzle_imp_for_layoutSubviews)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    override func _swizzle_imp_for_layoutSubviews() {
        _swizzle_imp_for_layoutSubviews()
        ConstraintManager.layout(self)
    }
}
