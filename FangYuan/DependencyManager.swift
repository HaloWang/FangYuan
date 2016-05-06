//
//  DependencyManager.swift
//  Halo
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import UIKit

// MARK: - Init & Properties
/// 约束依赖管理者
class DependencyManager {
    
    /// 单例
    static let singleton = DependencyManager()
    private init() {}
    
    /// 全部约束
    var dependencies = Set<Dependency>()
    
    /// 刚刚压入的约束
    var dependencyHolder: Dependency?
    
    /// 未设定的约束
    var unsetDependencies : [Dependency] {
        return dependencies.filter { dep in
            !dep.hasSet
        }
    }
    
    /// 有未设定的约束
    var hasUnsetDependency : Bool {
        for dep in dependencies {
            if !dep.hasSet {
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
    
    var hasDependencies: Bool {
        let _has = dependencies.count != 0
        return _has
    }
}

// MARK: - Private Methods
extension DependencyManager {
    func removeDuplicateDependencyOf(view:UIView, at direction:Dependency.Direction) -> Void {
        _ = dependencies.map { dep in
            if dep.to == view && dep.direction == direction {
                dependencies.remove(dep)
            }
        }
    }
    
    func removeUselessDependency() -> Void {
        dependencies.map { dep in
            if dep.to == nil && dep.from == nil {
                dependencies.remove(dep)
            }
        }
    }
    
    func allDependenciesLoaddedOf(view:UIView) -> Bool {
        for dep in dependencies {
            if dep.to == view && !dep.hasSet {
                return false;
            }
        }
        return true
    }
    
    func hasUnSetDependenciesOf(view:UIView) -> Bool {
        guard view.subviewUsingFangYuan else {
            return false
        }
    
        guard hasUnsetDependency else {
            return false
        }
        
        for subview in view.usingFangYuanSubviews {
            for dep in unsetDependencies {
                if dep.to == subview {
                    return true
                }
            }
        }
        
        return false
    }
    
    func removeUselessDep() {
        let dependenciesArray = dependencies.filter { dep in
            return dep.to != nil && dep.from != nil
        }
        dependencies = Set(dependenciesArray)
    }
    
    func layout(view: UIView) {
        if hasUnSetDependencies(view) {
            repeat {
                _ = view.usingFangYuanSubviews.map { subview in
                    if allDependenciesLoaddedOf(subview) {
                        subview.layoutWithFangYuan()
                        loadDependenciesOf(subview)
                    }
                }
            } while hasUnSetDependencies(view)
        } else {
            _ = view.usingFangYuanSubviews.map { subview in
                subview.layoutWithFangYuan()
            }
        }
    }

    func layouting(view: UIView) -> Bool {
        for dep in dependencies {
            if dep.from.superview == view {
                return true
            }
        }
        return false
    }
    
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
    
    func loadDependenciesOf(view: UIView) {
        
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
                _to.rulerY.a = _from.frame.origin.y + _from.frame.height + _value
            case .TopBottom:
                _to.rulerY.c = _from.superview!.frame.height - _from.frame.origin.y + _value
            case .RightLeft:
                _to.rulerX.a = _from.frame.origin.x + _from.frame.width + _value
            case .LeftRigt:
                _to.rulerX.c = _from.superview!.frame.width - _from.frame.origin.x + _value
            }
            dependency.hasSet = true
        }
    }
}

// MARK: - Public Methods
extension DependencyManager {
    
    class func layout(view:UIView) {
        singleton.removeUselessDep()
        singleton.layout(view)
    }
    
    /**
     推入约束
     
     - parameter from:      约束依赖视图
     - parameter direction: 约束方向
     */
    class func pushDependencyFrom(from:UIView, direction:Dependency.Direction) {
        singleton.dependencyHolder = Dependency(from: from, to: nil, direction: direction)
    }
    
    /**
     拉取约束
     
     - parameter to:        约束目标
     - parameter direction: 约束方向
     - parameter value:     约束固定值
     */
    class func popDependencyTo(to:UIView, direction:Dependency.Direction, value:CGFloat) {
        singleton.removeUselessDependency()
        singleton.removeDuplicateDependencyOf(to, at: direction)
        guard let holder = singleton.dependencyHolder else {
            return
        }
        
        holder.to = to
        holder.value = value
        
        singleton.dependencies.insert(holder)
        singleton.dependencyHolder = nil
    }
}
