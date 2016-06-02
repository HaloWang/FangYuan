//
//  FangYuanDispatch.swift
//  Pods
//
//  Created by 王策 on 16/6/2.
//
//

import Foundation

let _fangyuan_layout_queue = dispatch_queue_create("fangyuan.layout", DISPATCH_QUEUE_SERIAL)
let _fangyuan_layout_dispatch_group = dispatch_group_create()

internal func fangyuan_async(block:()->Void) {
    dispatch_group_async(_fangyuan_layout_dispatch_group, _fangyuan_layout_queue, block)
}

internal func fangyuan_waitLayoutQueue() {
    dispatch_group_wait(_fangyuan_layout_dispatch_group, DISPATCH_TIME_FOREVER)
}


