//
//  Assert.swift
//  FangYuan
//
//  Created by 王策 on 16/6/6.
//  Copyright © 2016年 WangCe. All rights reserved.
//

import Foundation

let _fy_noMainQueueAssert = "This method should invoke in \(_fangyuan_layout_queue)".fy_alert
let _fy_MainQueueAssert   = "This method should invoke in \(DispatchQueue.main)!".fy_alert

extension String {
    var fy_alert : String {
        return "⚠️ FangYuan:\n" + self
    }
}
