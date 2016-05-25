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

    lazy var avatarImageView = UIImageView()
    /// 昵称
    lazy var nickNameLabel   = UILabel()
    /// 动态
    lazy var messageTextView = UITextView()
    lazy var userBadgeImageView = UIImageView()
    lazy var commentsList    = UITableView(frame: CGRectZero, style: .Plain)
    lazy var deleteButton    = UIButton()
    lazy var likeButton      = UIButton()
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
        
        userBadgeImageView
            .superView(self)
            .backgroundColor(Blue.alpha(0.3))
        
        deleteButton
            .superView(self)
            .backgroundColor(Green.alpha(0.3))
        
        messageTextView
            .editable(false)
            .scrollEnabled(false)
            .superView(self)
            .backgroundColor(Yellow.alpha(0.3))
            .textContainerInset(UIEdgeInsetsZero)
        
        FangYuanDemo.BeginLayout {
            
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
            
            // TODO: BUG/unintuitive
            // How to implement reactive layout?
            // "LayoutOrder" can fix this
            // "WeakReferenseArray" is needed
            userBadgeImageView
                .fy_left(nickNameLabel.chainRight + 5)
                .fy_top(5)
                .fy_size(35.size)
        }
    }
    
    func set(item item:Item) {
        
        // TODO: 真的是在且仅在下一次 `layoutSubviews` 生效吗？那为什么上一个 tableView 动态高度为什么是可以的呢？
        // TODO: 当初 hasSet 属性不就是为了做这件事情吗？
        // TODO: 能不能让开发者想的更少呢？
        //  或者你也可以使用 _FYDComplexTableViewCell 中的代码来设定约束
        messageTextView.text = item.message
        nickNameLabel.text   = item.nickName
        
        deleteButton.fy_width(item.isMine ? 100 : 0)
        
        //  设定 nickNameLabel 的宽度，建议计算字符串展示面积的时候，缓存一下计算出来的面积
        let maxCGFloat = CGFloat(MAXFLOAT)
        nickNameLabel.fy_width((item.nickName as NSString).boundingRectWithSize(maxCGFloat.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:nickNameLabel.font], context: nil).size.width)
        
        // TODO: 这个方法走了两次，没有必要的！
        FYDComplexTableViewCell.layoutAndComputeDisplayHeight(item, layoutCell: self)
    }
    
    class func layoutAndComputeDisplayHeight(item:Item, layoutCell cell:FYDComplexTableViewCell?) -> CGFloat {
        
        let hasCellToLayout = cell != nil
        
        //  布局函数
        func layoutCellIfNeeded(@noescape block:(cell:FYDComplexTableViewCell)->Void) {
            guard hasCellToLayout else {
                return
            }
            block(cell: cell!)
        }
        
        var displayHeight : CGFloat = 0
        
        displayHeight += 5
        displayHeight += 40
        displayHeight += 3
        
        //  Layout TextView
        var messageDisplayHeight : CGFloat
        if item.message.length != 0 {
            messageDisplayHeight = (item.message as NSString).boundingRectWithSize(CGSize(width: ScreenWidth - 5.double, height:CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil).size.height
            
            displayHeight += messageDisplayHeight
            displayHeight += 3
        } else {
            messageDisplayHeight = 0
        }

        layoutCellIfNeeded { (cell) in
            cell.messageTextView.fy_height(messageDisplayHeight)
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
