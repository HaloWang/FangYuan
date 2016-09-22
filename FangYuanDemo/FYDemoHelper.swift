//
//  FYDemoHelper.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/9.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit

class FangYuanDemo {
    /// 仅仅是一个<font color=#CC6633>标识</font>，不要在意这个函数
    static func BeginLayout(_ layoutCode: ()-> Void) {
        layoutCode()
    }
}

extension UIView {
    var x: CGFloat {
        return frame.origin.x
    }
    
    var y: CGFloat {
        return frame.origin.y
    }
    
    var width: CGFloat {
        return frame.width
    }
    
    var height: CGFloat {
        return frame.height
    }
    
    var size: CGSize {
        return frame.size
    }
    
    var origin: CGPoint {
        return frame.origin
    }
}

extension CGRect {
    var x: CGFloat {
        return origin.x
    }
    
    var y: CGFloat {
        return origin.y
    }
}
