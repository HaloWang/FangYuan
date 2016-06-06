
//
//  FangYuanFrameworkHelper.swift
//  Pods
//
//  Created by 王策 on 16/6/6.
//
//

import Foundation

let _fy_noMainQueueAssert = "This method should invoke in \(_fangyuan_layout_queue)".fy_alert
let _fy_MainQueueAssert   = "This method should invoke in \(dispatch_get_main_queue())!".fy_alert

extension String {
    
    var fy_alert : String {
        return "⚠️ FangYuan:\n" + self
    }
    
}
