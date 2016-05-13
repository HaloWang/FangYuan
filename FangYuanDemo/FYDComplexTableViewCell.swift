//
//  FYDComplexTableViewCell.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import Halo
import FangYuan

class FYDComplexTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let nickNameLabel   = UILabel()
    let messageTextView = UITextView()
    let commentsList    = UITableView(frame: CGRectZero, style: .Plain)
    let deleteButton    = UIButton()
    let likeButton      = UIButton()
    var imageCollectionView : UICollectionView!
    
    func setWith(item:Item) {
        // TODO: 真的是在且仅在下一次 `layoutSubviews` 生效吗？那为什么上一个 tableView 动态高度为什么是可以的呢？
        // TODO: 当初 hasSet 属性不就是为了做这件事情吗？
        // TODO: 能不能让开发者想的更少呢？
        deleteButton.fy_width(item.isMine ? 100 : 0)
        nickNameLabel.fy_right(deleteButton.chainLeft)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nickNameLabel.superView(self).backgroundColor(Red.alpha(0.3))
        deleteButton.superView(self).backgroundColor(Green.alpha(0.3))
        
        nickNameLabel
            .fy_top(5)
            .fy_left(5)
            .fy_height(25)
//            .fy_right(deleteButton.chainLeft)
        
        deleteButton
            .fy_right(5)
            .fy_top(5)
            .fy_height(25)
//            .fy_width(50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
