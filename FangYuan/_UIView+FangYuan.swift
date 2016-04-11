//
//  _UIView+FangYuan.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import Foundation


private var kRulerX: Any?
private var kRulerY: Any?
private var kUsingFangYuan: Any?

// MARK: - _privte Associated Object

internal extension UIView {
    
    /// X 轴标尺
    var rulerX: Ruler {
        if objc_getAssociatedObject(self, &kRulerX) == nil {
            objc_setAssociatedObject(self, &kRulerX, Ruler(), .OBJC_ASSOCIATION_RETAIN)
        }
        return objc_getAssociatedObject(self, &kRulerX) as! Ruler
    }
    
    /// Y 轴表尺
    var rulerY: Ruler {
        if objc_getAssociatedObject(self, &kRulerY) == nil {
            objc_setAssociatedObject(self, &kRulerY, Ruler(), .OBJC_ASSOCIATION_RETAIN)
        }
        return objc_getAssociatedObject(self, &kRulerY) as! Ruler
    }
    
    var usingFangYuan: Bool {
        get {
            return objc_getAssociatedObject(self, &kUsingFangYuan) != nil
        }
        set {
            objc_setAssociatedObject(self, &kUsingFangYuan, newValue ? "" : nil, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

// MARK: - _private Computed Properties

internal extension UIView {
    
    // MARK: X
    
    var fy_left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            rulerX.a = newValue
//            if rulerX.c != nil {
//                frame.size.width = superview!.fy_width - fy_left - rulerX.c!
//            }
        }
    }
    
    var fy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            rulerX.b = newValue
            
//            frame.size.width = newValue
//            if rulerX.c != nil {
//                frame.origin.x = superview!.fy_width - fy_width - rulerX.c!
//            }
        }
    }
    
    var fy_right: CGFloat {
        get {
            return superview!.fy_width - chainRight
        }
        set {
            rulerX.c = newValue
//            if rulerX.a != nil {
//                frame.size.width = superview!.fy_width - fy_left - rulerX.c!
//            } else {
//                frame.origin.x = superview!.fy_width - fy_width - rulerX.c!
//            }
        }
    }
    
    // MARK: Y
    
    var fy_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
            rulerY.a = newValue
//            if rulerY.c != nil {
//                frame.size.height = superview!.fy_height - fy_top - rulerY.c!
//            }
        }
    }
    
    var fy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
            rulerY.b = newValue
//            if rulerY.c != nil {
//                frame.origin.y = superview!.fy_height - fy_height - rulerY.c!
//            }
        }
    }
    
    var fy_bottom: CGFloat {
        get {
            return superview!.fy_height - chainBottom
        }
        set {
            rulerY.c = newValue
//            if rulerY.a != nil {
//                frame.size.height = superview!.fy_height - fy_top - rulerY.c!
//            } else {
//                frame.origin.y = superview!.fy_height - fy_height - rulerY.c!
//            }
        }
    }
}