//
//  FYDDemoTableViewCell.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/1.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit

class FYDDemoTableViewCell: UITableViewCell {

    lazy var avatarImageView = UIImageView()
    lazy var nickNameLabel   = UILabel()
    lazy var timeLabel       = UILabel()
    lazy var messageTextView = UITextView()
    lazy var likeButton      = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(avatarImageView)
        addSubview(timeLabel)
        addSubview(messageTextView)
        addSubview(likeButton)
        addSubview(nickNameLabel)
        
        let _avatarImageViewRadius         = CGFloat(18)
        
        avatarImageView.backgroundColor    = UIColor(red: 1, green: 0.5, blue: 0.6, alpha: 1)
        avatarImageView.layer.cornerRadius = 18
        
        nickNameLabel.backgroundColor      = UIColor.whiteColor()
        nickNameLabel.font                 = UIFont.systemFontOfSize(10)
        
        timeLabel.backgroundColor          = UIColor(red: 0.6, green: 0.5, blue: 1, alpha: 1)
        
        messageTextView.backgroundColor    = UIColor(red: 0.8, green: 1, blue: 0.9, alpha: 1)
        messageTextView.scrollEnabled      = false
        
        likeButton.backgroundColor         = UIColor.whiteColor()
        likeButton.layer.cornerRadius = 3
        likeButton.layer.borderWidth = 0.5
        likeButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        //  昵称在头像的右边
        //  昵称的左边于头像的右边距离为 5
        nickNameLabel
            .fy_left(avatarImageView.chainRight + 5)
            .fy_top(2)
            .fy_right(15)
            .fy_height(10)
        
        let _timeLabelHeight = CGFloat(20)
        //  时间的左边于头像的右边距离为 5
        timeLabel
            .fy_height(_timeLabelHeight)
            .fy_right(15)
            .fy_left(avatarImageView.chainRight + 5)
            .fy_top((_avatarImageViewRadius * 2 + 5) - _timeLabelHeight)
        
        //  messageTextView.top 和 timeLabel.bottom 距离为 5
        //  但是高度可能是动态的，所以在这里我们在 init 方法中并不指定 messageTextView 的高度或距父视图底边距离
        messageTextView
            .fy_left(avatarImageView.chainRight + 5)
            .fy_top(timeLabel.chainBottom + 5)
            .fy_right(15)
            .fy_bottom(likeButton.chainTop + 10)
        
        //  距离父视图 (Cell) 右边的距离为 15
        //  距离父视图底部的距离为 2.5
        likeButton
            .fy_right(15)
            .fy_width(60)
            .fy_height(20)
            .fy_bottom(2.5)
        
        //  头像的位置相对固定
        avatarImageView
            .fy_left(5)
            .fy_top(5)
            .fy_width(_avatarImageViewRadius * 2)
            .fy_height(_avatarImageViewRadius * 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
