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
        
        func randomString(maxRepeat:Int, repeatString:String) -> String {
            return Array(count: (Int(arc4random()) % maxRepeat) + 1, repeatedValue: repeatString).reduce("") { $0 + $1 }
        }
        
        var items = [Item]()
        for _ in 0 ..< (Int(arc4random()) % 50) + 50 {
            let item       = Item()
            item.nickName  = randomString(3, repeatString: "昵称")
            item.message   = randomString(40 , repeatString: "动态内容")
            item.avatar    = ""
            item.isMine    = (arc4random() % 4 == 0)
            
            for _ in 0..<Int(arc4random()) % 5 {
                item.comments.append(randomString(10, repeatString: "评论内容"))
            }

            let hasImage = Int(arc4random()) % 3 == 0
            if hasImage {
                switch Int(arc4random()) % 10 {
                case 0...5:
                    item.imageURLs = Array(count: 1, repeatedValue: "")
                case 6...8:
                    item.imageURLs = Array(count: 2, repeatedValue: "")
                default:
                    item.imageURLs = Array(count: (Int(arc4random()) % 8 + 3), repeatedValue: "")
                }
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