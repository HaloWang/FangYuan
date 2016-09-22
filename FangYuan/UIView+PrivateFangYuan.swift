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
    
    /// - Note: 已经对弱引用数组做了尝试，效果不理想，直接将每个 usingFangYuan = true 的 UIView 加到 Set 中，Set.contains 方法会非常消耗性能（大概在 30-40 个 Weak.view 之间遍历的情况）
    /// - Warning: Set.remove 在移除 `hashValue = 0` 的 Element 时好像很不奏效！
    /// - Todo: 但是，这种给每个 UIView 加属性，并且不断调用的方法还是很讨厌，将来一定想办法移除之
    /// - Todo: 这个遍历是不是可以顺便把每个 UIView 的 constraint 个遍历出来？

    var usingFangYuanSubviews: [UIView] {
        return subviews.filter {
            $0.usingFangYuan
        }
    }
    
    func basicSetting(_ setting:@escaping ()->Void) {
        usingFangYuan = true
        _fy_layoutQueue {
            setting()
        }
    }
    
    func popConstraintAt(_ section: Constraint.Section, value: CGFloat) {
        switch section {
        case .left:
            rulerX.a = value
        case .right:
            rulerX.c = value
        case .top:
            rulerY.a = value
        case .bottom:
            rulerY.c = value
        }
        ConstraintManager.popConstraintTo(self, section: section, value: value)
    }
    
    func resetRelatedConstraintHorizontal(_ horizontal:Bool) {
        ConstraintManager.resetRelatedConstraintFrom(self, isHorizontal: horizontal)
    }

    /// 在约束已经求解完全的情况下进行 frame 的设置
    func layoutWithFangYuan() {
        
        assert(Thread.isMainThread, _fy_MainQueueAssert)
        assert(rulerX.full, "\(self)\nUIView.RulerX is not fully defined!\n".fy_alert)
        assert(rulerY.full, "\(self)\nUIView.RulerY is not fully defined!\n".fy_alert)

        //  X
        let newX = rulerX.a
        if newX != nil {
            if frame.origin.x != newX {
                frame.origin.x = newX!
            }
            let newWidth = rulerX.b ?? superview!.frame.width - newX! - rulerX.c
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
                frame.size.width = newWidth!
            }
        }

        //  Y
        let newY = rulerY.a
        if newY != nil {
            if frame.origin.y != newY {
                frame.origin.y = newY!
            }
            let newHeight = rulerY.b ?? superview!.frame.height - newY! - rulerY.c
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
                frame.size.height = newHeight!
            }
        }
    }
}

// MARK: - Associated Object

extension UIView {

    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/

    struct _fy_associatedKeys {
        static var ao: Any?
    }

    class AssociateObject {
        lazy var rulerX = Ruler()
        lazy var rulerY = Ruler()
        var usingFangYuan = false
    }

    var ao: AssociateObject {
        if let _ao = objc_getAssociatedObject(self, &_fy_associatedKeys.ao) {
            return _ao as! AssociateObject
        }
        let _ao = AssociateObject()
        objc_setAssociatedObject(self, &_fy_associatedKeys.ao, _ao, .OBJC_ASSOCIATION_RETAIN)
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

    struct _fy_uiview_once {
        static var token: Int = 0
    }

    override open class func initialize() {
        if _fy_uiview_once.token == 0 {
            _swizzle_layoutSubviews()
            _fy_uiview_once.token = 1
        }
    }

    class func _swizzle_layoutSubviews() {
        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(_swizzled_layoutSubviews)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    func _swizzled_layoutSubviews() {
        _swizzled_layoutSubviews()
        ConstraintManager.layout(self)
    }

}
