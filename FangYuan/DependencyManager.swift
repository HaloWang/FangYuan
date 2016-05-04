
import UIKit

/// 约束依赖管理者
class DependencyManager {

    private init() {

    }

    /// 单例
    static let sharedManager = DependencyManager()
    /// 全部约束
    var dependencies = [Dependency]()
    /// 刚刚压入的约束
    var dependencyHolder: Dependency?
    /// 推入约束
    func push(from: UIView?, to: UIView?, direction: Dependency.Direction, value: CGFloat = 0) {
        dependencyHolder = Dependency(from: from, to: to, direction: direction, value: value)
    }
    /// 推出约束
    func pop(from: UIView?, to: UIView?, direction: Dependency.Direction, value: CGFloat = 0) {
        
        guard let _h = dependencyHolder else {
            return
        }
        
        // TODO: Check direction，这里还要做一下安全检查
        guard direction == _h.direction else {
            print("⚠️ Whoops!")
            return
        }
        
        _h.to        = to
        _h.value     = value
        _h.direction = direction
        
        dependencies.append(_h)
        dependencyHolder = nil
    }
    
    var hasDependencies: Bool {
        let _has = dependencies.count != 0
        return _has
    }

    func layouting(view: UIView) -> Bool {
        for dep in dependencies {
            if dep.from.superview == view {
                return true
            }
        }
        return false
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
    
    // TODO: Swizzle UIViewController.viewDidDisappear ?
    func removeUselessDep() {
        dependencies = dependencies.filter { dep in
            dep.to != nil && dep.from != nil
        }
    }
    
    // TODO: Performence
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

    // TODO: Quick map?
    func layout(view: UIView) {
        if hasUnSetDependencies(view) {
            while hasUnSetDependencies(view) {
                _ = view.usingFangYuanSubviews.map { subview in
                    if allConstraintDefined(subview) {
                        subview.layoutWithFangYuan()
                        setDependency(subview)
                    }
                }
            }
        } else {
            _ = view.usingFangYuanSubviews.map { subview in
                subview.layoutWithFangYuan()
            }
        }
    }

    func setDependency(view: UIView) {

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

    // TODO: hasSet 这个点好像有点问题，这些约束只用装载一次吗？
    // TODO: 很严重，我完全不知道这段代码的意义！
    // TODO: 而且加上了之后，还出现了意想不到的问题！
    // TODO: 如何重新装载约束？
    // TODO: 动画？
    // TODO: 和其他布局库的兼容性？
    func allDepNeedReset() {
        _ = dependencies.map { dep in
            dep.hasSet = false
        }
    }

    func allConstraintDefined(view: UIView) -> Bool {
        removeUselessDep()
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
            let originalSelector = #selector(layoutSubviews)
            let swizzledSelector = #selector(_swizzle_imp_for_layoutSubviews)
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
        DependencyManager.sharedManager.layout(self)
        //  TODO: 这里这样使用会不会有什么问题？
//        dispatch_async(dispatch_get_main_queue()) { [weak self] in
//            guard let weakSelf = self else {
//                return
//            }
//            DependencyManager.sharedManager.layout(weakSelf)
//        }
    }
}

extension UIViewController {
    override public class func initialize() {
        _swizzle_viewDidDisappear()
    }
    
    class func _swizzle_viewDidDisappear() {
        dispatch_once(&swizzleToken) {
            let originalSelector = #selector(viewDidDisappear(_:))
            let swizzledSelector = #selector(_swizzle_imp_for_viewDidDisappear(_:))
            let originalMethod   = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod   = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func _swizzle_imp_for_viewDidDisappear(animated: Bool) {
        _swizzle_imp_for_viewDidDisappear(animated)
        DependencyManager.sharedManager.removeUselessDep()
    }
}

