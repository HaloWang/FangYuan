//
//  FYDemoHelper.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/9.
//  Copyright © 2016年 王策. All rights reserved.
//

import Foundation

class FangYuanDemo {
    /// 仅仅是一个<font color=#CC6633>标识</font>，不要在意这个函数
    static func BeginLayout(@noescape layoutCode: ()-> Void) {
        layoutCode()
    }
}
