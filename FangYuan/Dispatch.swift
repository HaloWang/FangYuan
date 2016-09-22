//
//  Dispatch.swift
//  FangYuan
//
//  Created by 王策 on 16/6/2.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import Foundation

let _fangyuan_layout_queue = DispatchQueue(label: "fangyuan.layout", attributes: [])

/// 进入布局线程
internal func _fy_layoutQueue(_ block:@escaping ()->Void) {
    _fangyuan_layout_queue.async(execute: block)
}

/// 等待布局线程
internal func _fy_waitLayoutQueue() {
    _fangyuan_layout_queue.sync(flags: .barrier, execute: {}) 
}
