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

let HPadding = 5.f
let VPadding = 3.f
let AIVSize  = 40.size

class FYDComplexTableViewCell: UITableViewCell {
    
    var singleImageMaxHeight : CGFloat {
        return ScreenHeight
    }
    
    var singleImageMinHeight : CGFloat {
        return 20
    }

    lazy var avatarImageView = UIImageView()
    /// 昵称
    lazy var nickNameLabel   = UILabel()
    /// 动态
    lazy var messageTextView = UITextView()
    lazy var userBadgeImageView = UIImageView()
    lazy var commentsList    = UITableView(frame: CGRectZero, style: .Plain)
    lazy var deleteButton    = UIButton()
    lazy var likeButton      = UIButton()
    lazy var singleImageView = UIImageView()
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
            .backgroundColor(Yellow.alpha(0.1))
            .textContainerInset(UIEdgeInsetsZero)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (ScreenWidth / 3.5).size
        
        imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView
            .scrollEnabled(false)
            .registerCellClass(UICollectionViewCell)
            .superView(self)
            .backgroundColor(Purple.alpha(0.3))
        
        singleImageView
            .superView(self)
            .contentMode(UIViewContentMode.ScaleAspectFill)
            .backgroundColor(Purple.alpha(0.3))
        
        FangYuanDemo.BeginLayout {
            
            avatarImageView
                .fy_frame(CGRect(x: HPadding, y: HPadding, width: AIVSize.width, height: AIVSize.height))
            
            messageTextView
                .fy_origin(CGPoint(x: HPadding, y: avatarImageView.chainBottom + VPadding))
                .fy_right(HPadding)
            
            imageCollectionView
                .fy_left(HPadding).fy_right(HPadding)
            
            singleImageView.fy_left(0).fy_right(0)
            
            nickNameLabel
                .fy_top(HPadding)
                .fy_left(avatarImageView.chainRight + VPadding)
                .fy_height(35)
            
            deleteButton
                .fy_right(HPadding)
                .fy_top(HPadding)
                .fy_height(25)
            
            // TODO: BUG/unintuitive
            // How to implement reactive layout?
            // "LayoutOrder" can fix this
            // "WeakReferenseArray" is needed
            userBadgeImageView
                .fy_top(HPadding)
                .fy_size(35.size)
        }
    }
    
    weak var item : Item!
    
    func set(item item:Item) {
        self.item = item
        
        // TODO: 真的是在且仅在下一次 `layoutSubviews` 生效吗？那为什么上一个 tableView 动态高度为什么是可以的呢？
        // TODO: 当初 hasSet 属性不就是为了做这件事情吗？
        // TODO: 能不能让开发者想的更少呢？
        // 或者你也可以使用 _FYDComplexTableViewCell 中的代码来设定约束
        messageTextView.text = item.message
        nickNameLabel.text   = item.nickName
        
        switch item.imageURLs.count {
        case 1:
            singleImageView.hidden = false
            imageCollectionView.hidden = true
        case 2:
            singleImageView.hidden = true
            imageCollectionView.hidden = false
        default:
            singleImageView.hidden = true
            imageCollectionView.hidden = true
        }
        
        if item.imageURLs.count > 1 {
            imageCollectionView.reloadData()
        }
        
        // TODO: 这个方法走了两次，没有必要的！
        layoutHorizontally()
        FYDComplexTableViewCell.layoutVerticallyAndComputeDisplayHeight(item, layoutCell: self)
    }
    
    func layoutHorizontally() {
        deleteButton.fy_width(item.isMine ? 100 : 0)
        //  设定 nickNameLabel 的宽度，建议计算字符串展示面积的时候，缓存一下计算出来的面积
        var nickNameDisplayWidth : CGFloat
        if let cachedWidth = item.nickNameDisplayWidthCache {
            nickNameDisplayWidth = cachedWidth
        } else {
            let maxCGFloat = CGFloat(MAXFLOAT)
            nickNameDisplayWidth = (item.nickName as NSString).boundingRectWithSize(maxCGFloat.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:nickNameLabel.font], context: nil).size.width
            item.nickNameDisplayWidthCache = nickNameDisplayWidth
        }
        nickNameLabel.fy_width(nickNameDisplayWidth)
        userBadgeImageView.fy_left(nickNameLabel.chainRight + 5)
    }
    
    /**
     If cell is nil, only calculate the height to display item.
     Called in `-tableView:heightForRowAtIndexPath:`.
     
     If cell is not nil, layout the cell vertically.
     
     - parameter item: item to display at the indexPath
     - parameter cell: cell to layout
     
     - returns: the height to display this item
     */
    class func layoutVerticallyAndComputeDisplayHeight(item:Item, layoutCell cell:FYDComplexTableViewCell?) -> CGFloat {
        
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
            if let cachedHeight = item.messageDisplayHeightCache {
                messageDisplayHeight = cachedHeight
            } else {
                messageDisplayHeight = (item.message as NSString).boundingRectWithSize(CGSize(width: ScreenWidth - 5.double, height:CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil).size.height
                item.messageDisplayHeightCache = messageDisplayHeight
            }
            displayHeight += messageDisplayHeight
            displayHeight += 3
        } else {
            messageDisplayHeight = 0
        }
        
        //  Layout Image CollectionView
        var imagesDisplayHeight : CGFloat
        let imageCount = item.imageURLs.count
        if imageCount != 0 {
            if imageCount == 1 {
                imagesDisplayHeight = 100
            } else {
                imagesDisplayHeight = (imageCount % 3) * 50 + 50
            }
        } else {
            imagesDisplayHeight = 0
        }
        displayHeight += imagesDisplayHeight

        layoutCellIfNeeded { (cell) in
            cell.messageTextView.fy_height(messageDisplayHeight)
            
            cell.singleImageView.fy_top(cell.messageTextView.chainBottom + 5)
            cell.singleImageView.fy_height(imagesDisplayHeight)
            
            cell.imageCollectionView.fy_top(cell.messageTextView.chainBottom + 5)
            cell.imageCollectionView.fy_height(imagesDisplayHeight)

        }
        
        displayHeight += 5
        
        return displayHeight
    }
}

// MARK: - UICollectionViewDataSource
extension FYDComplexTableViewCell : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(UICollectionViewCell.self, indexPath: indexPath)
        cell.backgroundColor(Purple.alpha(0.1))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.imageURLs.count ?? 0
    }
}

// MARK: - UICollectionViewDelegate
extension FYDComplexTableViewCell : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
