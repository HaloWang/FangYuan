//
//  FYDComplexDataSource.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import Foundation

class FYDComplexDataSource {
    static let data = [Item]()
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