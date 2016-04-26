//
//  _UIView+FangYuan.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import Foundation

// MARK: - _privte Associated Object

// TODO: 或许方圆可以变成一个协议？FangAble？😁然后为 CALayer 提供？PS: 主要是觉得这个文件所含有的内容越来越少了

internal extension UIView {
    
    // TODO: 这里也可以做成 JSPatch 那样，使用某个 object 作为 <##>
    
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
    
    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/

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