//
//  FangYuanManager.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import Foundation

/// 约束依赖
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

/// 约束依赖管理者
internal class DependencyManager {

    static let sharedManager = DependencyManager()
    
    var dependencies = [Dependency]()
    
    // TODO: Or should be only one?
    var caches = [Dependency]()
    
    var hasDependencies : Bool {
        let _has = dependencies.count != 0
        if _has {
            print(dependencies)
        }
        return _has
    }
    
    func layouting(view:UIView) -> Bool {
        return dependencies.filter { dependency in
            dependency.from.superview == view
        }.count != 0
    }
    
    var hasCaches : Bool {
        return caches.count != 0
    }
    
    var canPop : Bool {
        return hasCaches
    }
    
    // TODO: 真的要做成一个池子吗？
    
    /**
     将约束加入到约束池中
     
     - parameter direction: 约束方向
     - parameter view:      约束来自于哪个 view
     */
    func push(direction:Dependency.Direction, fromView view:UIView) {
        let dep = Dependency(from: view, direction: direction)
        caches.append(dep)
    }
    
    /**
     从约束池中取出某个约束
     
     - parameter view: 这个约束约束了谁
     */
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
    
    /// 从 dependencies 中移除某个 subview 的依赖
    class func removeDependencyFrom(view: UIView) {
        
        // 抽取所有需要设定的约束
        let _dependenciesShowP = sharedManager.dependencies.filter { dependency in
            dependency.from == view
        }
        
        // 设定这些约束
        _ = _dependenciesShowP.map { dependency in
            let _from = dependency.from
            let _to = dependency.to
            switch dependency.direction {
            case .BottomTop:
                _to.rulerY.a = _from.fy_top + _from.fy_height + _to.rulerY.a!
            case .LeftRigt:
                _to.rulerX.c = _from.superview!.fy_width - _from.fy_left + _to.rulerX.c!
            case .RightLeft:
                _to.rulerX.a = _from.fy_left + _from.fy_width + _to.rulerX.a!
            case .TopBottom:
                _to.rulerY.c = _from.superview!.fy_height - _from.fy_top + _to.rulerY.c!
            }
        }
        
        // 移除已设定的约束
        sharedManager.dependencies = sharedManager.dependencies.filter { dependency in
            dependency.from != view
        }
    }
}

var swizzleToken : dispatch_once_t = 0

// MARK: - Swizzling
private extension UIView {

    /// 不允许调用 load 方法了
    override public class func initialize() {
        _swizzle_layoutSubviews()
    }

    /// 交换实现
    private class func _swizzle_layoutSubviews() {
        dispatch_once(&swizzleToken) {
            let originalSelector = #selector(UIView.layoutSubviews)
            let swizzledSelector = #selector(UIView._swizzle_imp_for_layoutSubviews)
            let originalMethod   = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc func _swizzle_imp_for_layoutSubviews() {
        
        if DependencyManager.sharedManager.hasDependencies {
            while DependencyManager.sharedManager.layouting(self) && DependencyManager.sharedManager.hasDependencies {
                fangYuanLayout()
            }
        } else {
            if DependencyManager.sharedManager.layouting(self) {
                fangYuanLayout()
            }
        }

        _swizzle_imp_for_layoutSubviews()
    }
    
    func fangYuanLayout() {
        enumSubviews { subview in
            if subview.usingFangYuan && subview.allConstraintDefined {
                subview.layoutWithFangYuan()
                DependencyManager.removeDependencyFrom(subview)
            }
        }
    }
    
}

// MARK: - Using FangYuan
internal extension UIView {
    
    var allConstraintDefined : Bool {
        return DependencyManager.sharedManager.dependencies.filter { dependency in
            dependency.to == self
        }.count == 0
    }
    
    /// 遍历子视图
    func enumSubviews(callBack:(subview:UIView) -> Void) {
        _ = subviews.map { _subview in
            callBack(subview: _subview)
        }
    }
    
    // TODO: 这个算法还是应该被 UT 一下
    /// 在约束已经求解完全的情况下进行 frame 的设置
    func layoutWithFangYuan() {
        //  X
        if rulerX.a != nil {
            frame.origin.x = rulerX.a
            frame.size.width = rulerX.b ?? superview!.fy_width - rulerX.a - rulerX.c
        } else {
            frame.origin.x = superview!.fy_width - rulerX.b - rulerX.c
            frame.size.width = rulerX.b
        }
        
        //  Y
        if rulerY.a != nil {
            frame.origin.y = rulerY.a
            frame.size.height = rulerY.b ?? superview!.fy_height - rulerY.a - rulerY.c
        } else {
            frame.origin.y = superview!.fy_height - rulerY.b - rulerY.c
            frame.size.height = rulerY.b
        }
    }
}














