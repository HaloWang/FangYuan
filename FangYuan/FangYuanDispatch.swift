//
//  FangYuanDispatch.swift
//  FangYuan
//
//  Created by 王策 on 16/6/2.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import Foundation

let _fangyuan_layout_queue = dispatch_queue_create("fangyuan.layout", DISPATCH_QUEUE_SERIAL)

/// 进入布局线程
internal func _fy_layoutQueue(block:()->Void) {
    dispatch_async(_fangyuan_layout_queue, block)
}

/// 等待布局线程
internal func _fy_waitLayoutQueue() {
    dispatch_barrier_sync(_fangyuan_layout_queue) {}
}
