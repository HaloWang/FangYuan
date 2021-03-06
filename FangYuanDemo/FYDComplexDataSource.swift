//
//  FYDComplexDataSource.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import Foundation
import CoreGraphics
import Halo

func _fy_arc4random(_ v: Int) -> Int {
    return Int(arc4random() % UInt32(v))
}

func randomString(_ maxRepeat:Int, repeatString:String) -> String {
    return Array(repeating: repeatString, count: _fy_arc4random(maxRepeat) + 1).reduce("") { $0 + $1 }
}

func _fy_randomImageName(_ size:CGSize = CGSize(width: ScreenWidth, height: ScreenWidth)) -> String {
    let scale = UIScreen.main.scale
    let URLString = "https://unsplash.it/\(size.width * scale)/\(size.height * scale)?image=\(_fy_arc4random(1084))"
    return URLString
}

func _fy_randomImageNameS(_ count:Int) -> [String] {
    var names = [String]()
    for _ in 0..<count {
        let name : String
        switch count {
        case 2, 4:
            name = _fy_randomImageName(CGSize(width: ScreenWidth/2, height: ScreenWidth/2))
        default:
            name = _fy_randomImageName(CGSize(width: ScreenWidth/3, height: ScreenWidth/3))
        }
        names.append(name)
    }
    return names
}

class FYDComplexDataSource {
    static let data : [Item] = [
    ]
    
    static var randomData : [Item] {
        
        var items = [Item]()
        for _ in 0 ..< arc4random() % 50 + 50 {
            let item       = Item()
            item.nickName  = randomString(3, repeatString: "昵称")
            item.message   = randomString(40 , repeatString: "动态内容")
            item.avatar    = ""
            item.isMine    = arc4random() % 4 == 0
            
            for _ in 0 ..< arc4random() % 5 {
                item.comments.append(randomString(10, repeatString: "评论内容"))
            }

            let hasImage = arc4random() % 2 == 0
            if hasImage {
                item.firstImageSize = CGSize(width: _fy_arc4random(100).f + ScreenWidth, height: _fy_arc4random(100).f + ScreenWidth/1.7)
                switch arc4random() % 10 {
                case 0...5:
                    item.imageURLs = [_fy_randomImageName(ScreenWidth.size)]
                default:
                    item.imageURLs = _fy_randomImageNameS(_fy_arc4random(7) + 3)
                    assert(item.imageURLs.count <= 9, "WFT!")
                }
            }
            
            items.append(item)
        }
        return items
    }
}

class Item {
    var nickName  = ""
    var nickNameDisplayWidthCache : CGFloat?
    var message   = ""
    var messageDisplayHeightCache : CGFloat?
    var avatar    = ""
    var comments  = [String]()
    var imageURLs = [String]()
    var firstImageSize = CGSize.zero
    var isMine    = false
    var marked    = false
}
