//
//  FangYuanManager.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import Foundation

internal class Dependency {
    
    var from : UIView
    var type : Dependency.Type
    
    var to : UIView!
    
    // TODO: Maybe only X and Y
    enum Type {
        case BottomTop
        case LeftRigt
        case RightLeft
        case TopBottom
    }
    
    init(from : UIView , type: Dependency.Type) {
        self.from = from
        self.type = type
    }
}

internal class Manager {
    
    static let sharedManager = Manager()
    
    var dependencies = [Dependency]()
    
    // TODO: Or should be only one?
    var caches = [Dependency]()
    
    var hasCaches : Bool {
        return caches.count != 0
    }
    
    func push(type:Dependency.Type, fromView view:UIView) {
        let dep = Dependency(from: view, type: type)
        caches.append(dep)
    }
    
    func pop(toView view:UIView) {
        for dependency in caches {
            dependency.to = view
            dependencies.append(dependency)
        }
        caches.removeAll()
    }

    var op_queue : dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
}

var swizzleToken : dispatch_once_t = 0

internal extension UIView {
    
    override public class func initialize() {
        _swizzle_layoutSubviews()
    }
    
    private class func _swizzle_layoutSubviews() {
        dispatch_once(&swizzleToken) {
            let originalSelector = Selector("layoutSubviews")
            let swizzledSelector = Selector("_swizzle_imp_for_layoutSubviews")
            let originalMethod   = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    internal func _swizzle_imp_for_layoutSubviews() {
        
        _ = subviews.map { subview in
            
            guard subview.usingFangYuan else {
                return
            }
            
            // TODO: 等待依赖
            // TODO: 抽出方法
            // TODO: 对齐怎么办
            
            print(subview)
            print("✅")
            
            //  X
            if subview.rulerX.a != nil {
                subview.frame.origin.x = subview.rulerX.a!
                subview.frame.size.width = subview.rulerX.b ?? fy_width - subview.fy_left - subview.rulerX.c!
            } else {
                subview.frame.origin.x = fy_width - subview.fy_width - subview.rulerX.c!
                subview.frame.size.width = subview.rulerX.b!
            }
            
            //  Y
            if subview.rulerY.a != nil {
                subview.frame.origin.y = subview.rulerY.a!
                subview.frame.size.height = subview.rulerY.b ?? fy_height - subview.fy_top - subview.rulerY.c!
            } else {
                subview.frame.origin.y = fy_height - subview.fy_height - subview.rulerY.c!
                subview.frame.size.height = subview.rulerY.b!
            }
        }
        
        _swizzle_imp_for_layoutSubviews()
    }
}