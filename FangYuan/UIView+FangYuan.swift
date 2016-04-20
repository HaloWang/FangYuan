//
//  UIView+FangYuan.swift
//  Halo
//
//  Created by 王策 on 15/11/12.
//  Copyright © 2015年 WangCe. All rights reserved.
//

import UIKit
// MARK: - _privte Associated Object

private extension UIView {
    
    // Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace.
    // From http://nshipster.com/swift-objc-runtime/
    
    private struct AssociatedKeys {
        static var RulerX: Any?
        static var RulerY: Any?
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
}

// MARK: - Chainable Getter

public extension UIView {
    
    /// 描述某个 **view 右边** 距该 **view 左边**的关系时，使用该属性：
    ///
    /// someView.fy_right(self.chainLeft)
    var chainLeft: CGFloat {
        return superview == nil ? 0 : superview!.fy_width - fy_left
    }

    /// 描述某个 **view 左边** 距该 **view 右边**的关系时，使用该属性：
    ///
    /// someView.fy_left(self.chainRight)
    var chainRight: CGFloat {
        return fy_left + fy_width
    }
    
    /// 描述某个 **view 顶部** 距该 **view 底部**的关系时，使用该属性：
    ///
    /// someView.fy_top(self.chainBottom)
    var chainBottom: CGFloat {
        return fy_top + fy_height
    }

    /// 描述某个 **view 底部** 距该 **view 顶部**的关系时，使用该属性：
    ///
    /// someView.fy_bottom(self.chainTop)
    var chainTop: CGFloat {
        return superview == nil ? 0 : superview!.fy_height - fy_top
    }
}

// MARK: - Chainable Method

public extension UIView {

    // MARK: X

    /// 设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
    func fy_left(left: CGFloat) -> Self {
        self.fy_left = left
        return self
    }

    /// 设定某个 UIView 的宽度，相当于 width
    func fy_width(width: CGFloat) -> Self {
        self.fy_width = width
        return self
    }

    /// 设定某个 UIView 右边距离其 superview 右边的距离
    func fy_right(right: CGFloat) -> Self {
        self.fy_right = right
        return self
    }

    // MARK: Y

    /// 设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
    func fy_top(top: CGFloat) -> Self {
        self.fy_top = top
        return self
    }

    /// 设定某个 UIView 的高度，相当于 height
    func fy_height(height: CGFloat) -> Self {
        self.fy_height = height
        return self
    }

    /// 设定某个 UIView 底部距离其 superview 底部的距离
    func fy_bottom(bottom: CGFloat) -> Self {
        self.fy_bottom = bottom
        return self
    }

    // MARK: Edge

    /// 设定某个 UIView 四个边距离其父视图相对四边的距离
    func fy_edge(edge: UIEdgeInsets) -> Self {
        fy_top    = edge.top
        fy_bottom = edge.bottom
        fy_left   = edge.left
        fy_right  = edge.right
        return self
    }
}

// MARK: - _private Computed Properties

public extension UIView {
    
    // MARK: X

    private var fy_left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
            if superview == nil {
                return
            }
            rulerX.a = newValue
            if rulerX.c != nil {
                frame.size.width = superview!.fy_width - fy_left - rulerX.c!
            }
        }
    }

    private var fy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
            if superview == nil {
                return
            }
            rulerX.b = newValue
            if rulerX.c != nil {
                frame.origin.x = superview!.fy_width - fy_width - rulerX.c!
            }
        }
    }

    private var fy_right: CGFloat {
        get {
            if superview == nil {
                return 0
            }
            return superview!.fy_width - chainRight
        }
        set {
            if superview == nil {
                return
            }
            rulerX.c = newValue
            if rulerX.a != nil {
                frame.size.width = superview!.fy_width - fy_left - rulerX.c!
            } else {
                frame.origin.x = superview!.fy_width - fy_width - rulerX.c!
            }
        }
    }
    
    // MARK: Y

    private var fy_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
            if superview == nil {
                return
            }
            rulerY.a = newValue
            if rulerY.c != nil {
                frame.size.height = superview!.fy_height - fy_top - rulerY.c!
            }
        }
    }

    private var fy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
            if superview == nil {
                return
            }
            rulerY.b = newValue
            if rulerY.c != nil {
                frame.origin.y = superview!.fy_height - fy_height - rulerY.c!
            }
        }
    }

    private var fy_bottom: CGFloat {
        get {
            if superview == nil {
                return 0
            }
            return superview!.fy_height - chainBottom
        }
        set {
            if superview == nil {
                return
            }
            rulerY.c = newValue
            if rulerY.a != nil {
                frame.size.height = superview!.fy_height - fy_top - rulerY.c!
            } else {
                frame.origin.y = superview!.fy_height - fy_height - rulerY.c!
            }
        }
    }
}
