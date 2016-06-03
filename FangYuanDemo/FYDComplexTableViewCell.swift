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
let FontSize = 14.f

// TODO: 发现了布局时的 BUG
// TODO: 为什么 UITextView.text 的调用那么耗时？有什么优化办法？
// TODO: 什么时候能让 FangYuan 变成纯配置式 DSL？
// 比如：textView.fy_rx_height(message.displayHeight)

class FYDComplexTableViewCell: UITableViewCell {
    
    let singleImageMaxHeight    = ScreenHeight
    let singleImageMinHeight    = 20

    lazy var avatarImageView    = UIImageView()
    lazy var nickNameLabel      = UILabel()
    lazy var messageTextView    = UITextView()
    lazy var userBadgeImageView = UIImageView()
    lazy var commentsList       = UITableView(frame: CGRectZero, style: .Plain)
    lazy var deleteButton       = UIButton()
    lazy var likeButton         = UIButton()
    lazy var singleImageView    = UIImageView()
    
    var imageCollectionView : UICollectionView!
    weak var item : Item!
    
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
            .font(UIFont.systemFontOfSize(FontSize))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView
            .scrollEnabled(false)
            .registerCellClass(FYDImageDisplayCollectionViewCell)
            .superView(self)
            .backgroundColor(White)
        
        singleImageView
            .superView(self)
            .contentMode(UIViewContentMode.ScaleAspectFill)
            .backgroundColor(Purple.alpha(0.3))
            .clipsToBounds(true)
        
        FangYuanDemo.BeginLayout {
            
            avatarImageView
                .fy_frame(CGRect(x: HPadding, y: HPadding, width: AIVSize.width, height: AIVSize.height))
            
            messageTextView
                .fy_origin(CGPoint(x: HPadding, y: avatarImageView.chainBottom + VPadding))
                .fy_right(HPadding)
            
            imageCollectionView
                .fy_left(0)
                .fy_right(0)
                .fy_top(messageTextView.chainBottom + 5)
            
            singleImageView
                .fy_left(0)
                .fy_right(0)
                .fy_top(messageTextView.chainBottom + 5)
            
            nickNameLabel
                .fy_top(HPadding)
                .fy_left(avatarImageView.chainRight + VPadding)
                .fy_height(35)
            
            deleteButton
                .fy_right(HPadding)
                .fy_top(HPadding)
                .fy_height(25)

            userBadgeImageView
                .fy_top(HPadding)
                .fy_size(35.size)
                .fy_left(nickNameLabel.chainRight + 5)
        }
    }
    
    func set(item item:Item) {
        
        // TODO: 这里的传值写的不好
        
        self.item = item
        func setValues() {
            messageTextView.text = item.message
            nickNameLabel.text   = item.nickName
            switch item.imageURLs.count {
            case 0:
                singleImageView.hidden = true
                imageCollectionView.hidden = true
            case 1:
                singleImageView.image(named: item.imageURLs.first!)
                singleImageView.hidden = false
                imageCollectionView.hidden = true
            default:
                singleImageView.hidden = true
                imageCollectionView.hidden = false
            }
            
            if item.imageURLs.count > 1 {
                imageCollectionView.reloadData()
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            setValues()
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
    }
    
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
                messageDisplayHeight = (item.message as NSString).boundingRectWithSize(CGSize(width: ScreenWidth - 5.double, height:CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(FontSize)], context: nil).size.height
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
        switch imageCount {
        case 0:
            imagesDisplayHeight = 0
        case 1:
            imagesDisplayHeight = item.firstImageSize.height * (ScreenWidth / item.firstImageSize.width)
        case 2, 4:
            let imageWidth = ScreenWidth / 2
            imagesDisplayHeight = (imageCount / 2) * imageWidth + (imageCount % 2 > 0 ? imageWidth : 0)
        default:
            let imageWidth = ScreenWidth / 3
            imagesDisplayHeight = (imageCount / 3) * imageWidth  + (imageCount % 3 > 0 ? imageWidth : 0)
        }
        displayHeight += imagesDisplayHeight

        layoutCellIfNeeded { (cell) in
            cell.messageTextView.fy_height(messageDisplayHeight)
            cell.singleImageView.fy_height(imagesDisplayHeight)
            cell.imageCollectionView.fy_height(imagesDisplayHeight)
        }
        
        displayHeight += 5
        
        return displayHeight
    }
}

// MARK: - UICollectionViewDataSource
extension FYDComplexTableViewCell : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(FYDImageDisplayCollectionViewCell.self, indexPath: indexPath)
        cell.backgroundColor(Purple.alpha(0.1))
        if indexPath.row < item.imageURLs.count {
            // TODO: Crash: Index out of range
            cell.imageView.image(named: item.imageURLs[indexPath.row])
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let item = item else {
            return 0
        }
        return item.imageURLs.count > 1 ? item.imageURLs.count : 0
    }
}

// MARK: - UICollectionViewDelegate
extension FYDComplexTableViewCell : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension FYDComplexTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let item = item else {
            return CGSizeZero
        }
        switch item.imageURLs.count {
        case 0, 1:
            return CGSizeZero
        case 2, 4:
            return CGSizeMake(ScreenWidth / 2 - 0.5, ScreenWidth / 2 - 0.5)
        default:
            return (ScreenWidth / 3 - 1).size
        }
    }
}

class FYDImageDisplayCollectionViewCell : UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView
            .superView(self)
            .contentMode(UIViewContentMode.ScaleAspectFill)
            .clipsToBounds(true)
        
        FangYuanDemo.BeginLayout { 
            imageView
                .fy_edge(UIEdgeInsetsZero)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




