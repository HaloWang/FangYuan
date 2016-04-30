//
//  FangYuanManager.swift
//  Pods
//
//  Created by 王策 on 16/4/11.
//
//

import UIKit

/// 什么时候移除无效的约束？

/// 约束依赖管理者
class DependencyManager {
    /// 单例
    static let sharedManager = DependencyManager()
    /// 全部约束
    var dependencies = [Dependency]()
    /// 刚刚压入的约束
    var dependencyHolder: Dependency?
    /// 推入约束
    func push(from: UIView?, to: UIView?, direction: Dependency.Direction, value: CGFloat = 0) {
        print("Push")
        dependencyHolder = Dependency(from: from, to: to, direction: direction, value: value)
        print(dependencyHolder!)
    }
    /// 推出约束
    func pop(from: UIView?, to: UIView?, direction: Dependency.Direction, value: CGFloat = 0) {
        
        guard let _h = dependencyHolder else {
            return
        }
        
        print("Pop")
        _h.to        = to
        _h.value     = value
        _h.direction = direction
        
        dependencies.append(_h)
        print(_h)
        dependencyHolder = nil
    }
    
    var hasDependencies: Bool {
        let _has = dependencies.count != 0
        return _has
    }

    func layouting(view: UIView) -> Bool {
        return dependencies.filter { dependency in
            dependency.from.superview == view
        }.count != 0
    }

    var hasUnSetDependencies: Bool {
        return dependencies.filter { dependency in
            dependency.hasSet == false
        }.count != 0
    }
    
    var unsetDeps : [Dependency] {
        return dependencies.filter {
            !$0.hasSet
        }
    }
    
    func removeUselessDep() {
        dependencies = dependencies.filter { dep in
            dep.to != nil && dep.from != nil
        }
    }
    
    // TODO: 性能优化
    func hasUnSetDependencies(view: UIView) -> Bool {

        //  正在设定某 view.subviews
        guard view.subviewUsingFangYuan else {
            return false
        }
        
        //  还有未设定的约束
        let needSetDeps = unsetDeps
        guard needSetDeps.count != 0 else {
            return false
        }

        for usingFangYuanSubview in view.usingFangYuanSubviews {
            for dep in needSetDeps {
                if dep.to == usingFangYuanSubview {
                    return true
                }
            }
        }
        
        return false
    }

    func setDependencyFrom(view: UIView) {

        // 抽取所有需要设定的约束
        let _dependenciesShowP = dependencies.filter { dependency in
            dependency.from == view
        }

        // 设定这些约束
        _ = _dependenciesShowP.map { dependency in
            let _from = dependency.from
            let _to = dependency.to
            let _value = dependency.value
            switch dependency.direction {
            case .BottomTop:
                _to.rulerY.a = _from.fy_top + _from.fy_height + _value
            case .LeftRigt:
                _to.rulerX.c = _from.superview!.fy_width - _from.fy_left + _value
            case .RightLeft:
                _to.rulerX.a = _from.fy_left + _from.fy_width + _value
            case .TopBottom:
                _to.rulerY.c = _from.superview!.fy_height - _from.fy_top + _value
            }
            dependency.hasSet = true
        }
    }

    func allDepNeedReset() {
        _ = dependencies.map { dep in
            dep.hasSet = false
        }
    }

    func allConstraintDefined(view: UIView) -> Bool {
        return dependencies.filter { dep in
            dep.to == view
        }.filter { dep in
            dep.hasSet == false
        }.count == 0
    }

    func managering(view: UIView) -> Bool {
        for subview in view.subviews {
            for dep in dependencies {
                if dep.from == subview {
                    return true
                }
            }
        }
        return false
    }
}

var swizzleToken: dispatch_once_t = 0

// MARK: - Swizzling
extension UIView {

    // TODO: 这里还是有访问权限的警告
    /// 不允许调用 load 方法了
    override public class func initialize() {
        _swizzle_layoutSubviews()
    }

    /// 交换实现
    class func _swizzle_layoutSubviews() {
        dispatch_once(&swizzleToken) {
            let originalSelector = #selector(UIView.layoutSubviews)
            let swizzledSelector = #selector(UIView._swizzle_imp_for_layoutSubviews)
            let originalMethod   = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func _swizzle_imp_for_layoutSubviews() {
        _swizzle_imp_for_layoutSubviews()
        
        guard subviewUsingFangYuan else {
            return
        }

        let dm = DependencyManager.sharedManager
        dm.removeUselessDep()
        
        if dm.hasUnSetDependencies(self) {
            while dm.hasUnSetDependencies(self) {
                _ = usingFangYuanSubviews.map { subview in
                    if dm.allConstraintDefined(subview) {
                        subview.layoutWithFangYuan()
                        dm.setDependencyFrom(subview)
                    }
                }
            }
        } else {
            enumSubviews { subview in
                if subview.usingFangYuan {
                    subview.layoutWithFangYuan()
                }
            }
        }
    }
}

// MARK: - Using FangYuan
extension UIView {
    
    // TODO: 性能优化
    var subviewUsingFangYuan : Bool {
        for subview in subviews {
            if subview.usingFangYuan {
                return true
            }
        }
        return false
    }
    
    /// 使用 FangYuan 的 subview
    var usingFangYuanSubviews : [UIView] {
        return subviews.filter { subview in
            return subview.usingFangYuan
        }
    }
    
    /// 遍历子视图，主要是忽略警告
    func enumSubviews(@noescape callBack:(subview: UIView) -> Void) {
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
