//
//  TestHelper.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import Foundation
import UIKit

/// 创建随机 CGFloat 值
func RandomCGFloat() -> CGFloat {
    return CGFloat(arc4random() % 100)
}

/// 创建测试环境
func CreateEnvironment(@noescape finish:(superview : UIView, view : UIView) -> Void) -> CGRect {
    
    let superview = UIView()
    superview.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    
    let view = UIView()
    
    superview.addSubview(view)
    
    finish(superview: superview, view: view)
    
    return view.frame
}