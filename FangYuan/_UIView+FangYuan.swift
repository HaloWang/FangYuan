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

// TODO: 或许方圆可以变成一个协议？FangAble？😁然后为 CALayer 提供？PS: 主要是觉得这个文件所含有的内容越来越少了

internal extension UIView {
    
    // TODO: 这里也可以做成 JSPatch 那样
    
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
    /// 该 View 是否在使用 FangYuan
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