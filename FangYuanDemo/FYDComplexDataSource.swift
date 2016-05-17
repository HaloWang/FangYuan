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
    
    static var randomData : [Item] {
        var items = [Item]()
        for _ in 0 ..< (Int(arc4random()) % 50) + 50 {
            let item       = Item()
            item.nickName  = "昵称"
            item.message   = Array(count: (Int(arc4random()) % 40) + 1, repeatedValue: "动态内容").reduce("") { $0 + $1 }
            item.avatar    = ""
            item.imageURLs = Array(count: (Int(arc4random()) % 10), repeatedValue: "")
            item.isMine    = (arc4random() % 4 == 0)
            for _ in 0..<Int(arc4random()) % 5 {
                item.comments.append(Array(count: (Int(arc4random()) % 20), repeatedValue: "评论").reduce("") { $0 + $1 })
            }
            items.append(item)
        }
        return items
    }
}

class Item {
    var nickName  = ""
    var message   = ""
    var avatar    = ""
    var comments  = [String]()
    var imageURLs = [String]()
    var isMine    = false
    var marked    = false
}