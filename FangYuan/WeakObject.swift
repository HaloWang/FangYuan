//
//  WeakObject.swift
//  Pods
//
//  Created by 王策 on 16/5/31.
//
//

import UIKit

typealias WeakView = Weak<UIView>
typealias ViewTree = Dictionary<WeakView, [WeakView]?>
typealias ViewCons = Dictionary<WeakView, Set<Constraint>?>

func ==<V:NSObject>(lhs: Weak<V>, rhs: Weak<V>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Weak<V:NSObject>: Hashable {
    
    private(set) weak var obj: V?
    
    init (_ view: V?) {
        self.obj = view
    }
    
    // TODO: 使用所存储的 obj.hash 作为 hashValue 有意义吗？
    var hashValue: Int {
        guard let obj = obj else {
            return 0
        }
        return obj.hash
    }
}

extension UIView {
    var weak: Weak<UIView> {
        return Weak(self)
    }
}