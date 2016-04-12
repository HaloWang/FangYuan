//
//  FangYuanManager.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import Foundation

internal class Dependency : CustomStringConvertible {
    
    var from : UIView
    var direction: Direction
    
    var to : UIView!
    
    var description : String {
        return "\nDependency:\n✅direction: \(direction) \n⏬from: \(from) \n⏫to: \(to)\n"
    }
    
    // TODO: Maybe only X and Y
    enum Direction {
        case BottomTop
        case LeftRigt
        case RightLeft
        case TopBottom
    }
    
    init(from : UIView , direction: Dependency.Direction) {
        self.from = from
        self.direction = direction
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
    
    var canPop : Bool {
        return hasCaches
    }
    
    func push(direction:Dependency.Direction, fromView view:UIView) {
        print("✅", "pushing!", direction)
        let dep = Dependency(from: view, direction: direction)
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
            
            print(Manager.sharedManager.dependencies)
            
            _ = Manager.sharedManager.dependencies.map { dependency in
                if dependency.to == subview {
                    //  该 subview 有依赖其他 subview
                    
                    
                    
                    return
                }
            }
            
            // TODO: 等待依赖（递归）
            // TODO: 抽出方法
            // TODO: 对齐怎么办，比如说：想让两个 UIView 的底边对齐
            
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