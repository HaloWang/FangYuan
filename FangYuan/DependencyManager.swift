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
    
    // TODO: Set vs Array (performance) ?
    /// 全部约束
    var dependencies = Set<Dependency>()
    
    /// 刚刚压入的约束
    var dependencyHolder: Dependency?
    
    /// 未设定约束相关信息
    var unsetDependencyInfo : (has: Bool, unsetDependencies: [Dependency]) {
        let unsetDeps = dependencies.filter { dep in
            !dep.hasSet
        }
        return (unsetDeps.count != 0, unsetDeps)
    }
}

// MARK: - Public Methods
extension DependencyManager {
    
    /**
     从某个视图得到约束
     
     - parameter from:      约束依赖视图
     - parameter direction: 约束方向
     */
    class func getDependencyFrom(from:UIView, direction:Dependency.Direction) {
        singleton.dependencyHolder = Dependency(from: from, to: nil, direction: direction)
    }
    
    /**
     设定约束到某个视图上
     
     - parameter to:        约束目标
     - parameter direction: 约束方向
     - parameter value:     约束固定值
     */
    class func setDependencyTo(to:UIView, direction:Dependency.Direction, value:CGFloat) {
        singleton.removeUselessDep()
        singleton.removeDuplicateDependencyOf(to, at: direction)
        // TODO: 未实现
        singleton.removeAndWarningCyclingDependency()
        guard let holder = singleton.dependencyHolder else {
            return
        }
        
        holder.to = to
        holder.value = value
        
        singleton.dependencies.insert(holder)
        singleton.dependencyHolder = nil
    }
    
    class func layout(view:UIView) {
        
        let info = view.usingFangYuanInfo
        
        guard info.hasUsingFangYuanSubview else {
            return
        }
        
        singleton.layout(info.usingFangYuanSubviews)
    }
}

// MARK: - Private Methods

// MARK: Layout
private extension DependencyManager {
    
    // TODO: allDependenciesLoaddedOf 不是每次都要遍历的，可以提前生成一个渲染序列，这个渲染序列的副产品就是检查是否有依赖循环
    /// 核心布局方法
    func layout(views: [UIView]) {
        if hasUnsetDependenciesOf(views) {
            repeat {
                _ = views.map { subview in
                    if allDependenciesLoaddedOf(subview) {
                        subview.layoutWithFangYuan()
                        loadDependenciesOf(subview)
                    }
                }
            } while hasUnsetDependenciesOf(views)
        } else {
            _ = views.map { subview in
                subview.layoutWithFangYuan()
            }
        }
    }
    
    func hasUnsetDependenciesOf(views:[UIView]) -> Bool {
        
        let dependencyInfo = unsetDependencyInfo
        
        guard dependencyInfo.has else {
            return false
        }
        
        for view in views {
            for dep in dependencyInfo.unsetDependencies {
                if dep.to == view {
                    return true
                }
            }
        }
        
        return false
    }
    
    func allDependenciesLoaddedOf(view:UIView) -> Bool {
        for dep in dependencies {
            if dep.to == view && !dep.hasSet {
                return false;
            }
        }
        return true
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

// MARK: Assistant
private extension DependencyManager {
    
    // TODO: 这里是不是可以用上 Set ?
    func removeDuplicateDependencyOf(view:UIView, at direction:Dependency.Direction) {
        _ = dependencies.map { dep in
            if dep.to == view && dep.direction == direction {
                dependencies.remove(dep)
            }
        }
    }
    
    // TODO: 时间复杂度？deps × deps ?
    // TODO: 布局实际上也像 node.js 那样是一个高并发的东西？
    func removeAndWarningCyclingDependency() {
        
    }
    
    func removeUselessDep() {
        let dependenciesArray = dependencies.filter { dep in
            return dep.to != nil && dep.from != nil
        }
        dependencies = Set(dependenciesArray)
    }
}
