//
//  FYDComplexDataSource.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import Foundation

class FYDComplexDataSource {
    static let data : [Item] = [
    ]
    
    class func requestData() -> [Item] {
        var items = [Item]()
        for _ in 0...99 {
            let item = Item()
            item.isMine = (arc4random() % 2 == 0)
            items.append(item)
        }
        return items
    }
}

class Item {
    var nickName      = ""
    var message       = ""
    var avatar        = ""
    var commentsCount = 0
    var comments      = [String]()
    var imageURLs     = [String]()
    var isMine        = false
    var marked        = false
}