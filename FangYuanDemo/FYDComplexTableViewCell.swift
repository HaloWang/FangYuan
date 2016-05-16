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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImageView
            .superView(self)
            .backgroundColor(Blue.alpha(0.3))
        
        nickNameLabel
            .superView(self)
            .backgroundColor(Red.alpha(0.3))
        
        deleteButton
            .superView(self)
            .backgroundColor(Green.alpha(0.3))
        
        messageTextView
            .editable(false)
            .scrollEnabled(false)
            .superView(self)
            .backgroundColor(Yellow.alpha(0.3))
        
        avatarImageView
            .fy_frame(CGRect(x: 5, y: 5, width: 40, height: 40))
        
        messageTextView
            .fy_origin(CGPoint(x: 5, y: avatarImageView.chainBottom + 3))
            .fy_right(5)
        
        nickNameLabel
            .fy_top(5)
            .fy_left(avatarImageView.chainRight + 3)
            .fy_height(35)
        
        deleteButton
            .fy_right(5)
            .fy_top(5)
            .fy_height(25)
    }
    
    func set(item:Item) {
        
        // TODO: 真的是在且仅在下一次 `layoutSubviews` 生效吗？那为什么上一个 tableView 动态高度为什么是可以的呢？
        // TODO: 当初 hasSet 属性不就是为了做这件事情吗？
        // TODO: 能不能让开发者想的更少呢？
        //  或者你也可以使用 _FYDComplexTableViewCell 中的代码来设定约束
        messageTextView.text = item.message
        
        deleteButton.fy_width(item.isMine ? 100 : 0)
        nickNameLabel.fy_right(deleteButton.chainLeft + 3)
        messageTextView.fy_height(50)
        
        FYDComplexTableViewCell.layoutAndComputeDisplayHeight(item, layoutCell: self)
    }
    
    class func layoutAndComputeDisplayHeight(item:Item, layoutCell cell:FYDComplexTableViewCell?) -> CGFloat {
        
        let hasCellToLayout = cell != nil
        
        var displayHeight : CGFloat = 0
        
        displayHeight += 5
        displayHeight += 40
        displayHeight += 3
        
        //  Layout TextView
        var messageDisplayHeight : CGFloat
        if !item.message.isAllSpace {
            messageDisplayHeight = (item.message as NSString).boundingRectWithSize(CGSize(width: ScreenWidth - 5.double, height:CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil).size.height
            
            displayHeight += messageDisplayHeight
            displayHeight += 3
        } else {
            messageDisplayHeight = 0
        }
        
        if hasCellToLayout {
            cell!.messageTextView.fy_height(messageDisplayHeight)
        }
        
        displayHeight += 5
        
        return displayHeight
    }
    
}

class _FYDComplexTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let nickNameLabel   = UILabel()
    let messageTextView = UITextView()
    let commentsList    = UITableView(frame: CGRectZero, style: .Plain)
    let deleteButton    = UIButton()
    let likeButton      = UIButton()
    var imageCollectionView : UICollectionView!
    
    func setWith(item:Item) {
        deleteButton.hidden(!item.isMine)
        nickNameLabel.fy_right(deleteButton.hidden ? 5 : deleteButton.chainLeft)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nickNameLabel.superView(self).backgroundColor(Red.alpha(0.3))
        deleteButton.superView(self).backgroundColor(Green.alpha(0.3))
        
        nickNameLabel
            .fy_top(5)
            .fy_left(5)
            .fy_height(25)
        
        deleteButton
            .fy_right(5)
            .fy_top(5)
            .fy_height(25)
            .fy_width(50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
