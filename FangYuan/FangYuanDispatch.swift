//
//  FangYuanDispatch.swift
//  FangYuan
//
//  Created by 王策 on 16/6/2.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import Foundation

let _fangyuan_layout_queue = dispatch_queue_create("fangyuan.layout", DISPATCH_QUEUE_SERIAL)
let _fangyuan_layout_dispatch_group = dispatch_group_create()

/// 进入布局线程
internal func _fy_layoutQueue(block:()->Void) {
    dispatch_group_async(_fangyuan_layout_dispatch_group, _fangyuan_layout_queue, block)
}

/// 等待布局线程
internal func _fy_waitLayoutQueue() {
    dispatch_group_wait(_fangyuan_layout_dispatch_group, DISPATCH_TIME_FOREVER)
}
