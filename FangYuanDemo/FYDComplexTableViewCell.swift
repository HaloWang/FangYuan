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
import Kingfisher

let HPadding = 5.f
let VPadding = 3.f
let AIVSize  = 40.size
let FontSize = 14.f
let CellVerticalPadding = 11.f

/// - Todo: 为什么 UITextView.text 的调用那么耗时？有什么优化办法？
/// - Todo: 什么时候能让 FangYuan 变成纯配置式 DSL？
// 比如：textView.fy_rx_height(message.displayHeight)

class FYDComplexTableViewCell: UITableViewCell {
    
    let singleImageMaxHeight    = ScreenHeight
    let singleImageMinHeight    = 20

    lazy var avatarImageView    = UIImageView()
    lazy var nickNameLabel      = UILabel()
    lazy var messageTextView    = UITextView()
    lazy var userBadgeImageView = UIImageView()
    lazy var deleteButton       = UIButton()
    lazy var likeButton         = UIButton()
    lazy var singleImageView    = UIImageView()
    lazy var holderView         = UIView()
    
    var imageCollectionView : UICollectionView!
    weak var item : Item!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor(HEX("f1f1f1"))
        
        holderView
            .superView(self)
            .backgroundColor(White)
        
        avatarImageView
            .superView(holderView)
            .backgroundColor(Blue.alpha(0.3))
        
        nickNameLabel
            .superView(holderView)
            .backgroundColor(Red.alpha(0.3))
        
        userBadgeImageView
            .superView(holderView)
            .backgroundColor(Blue.alpha(0.3))
        
        deleteButton
            .superView(holderView)
            .backgroundColor(Green.alpha(0.3))
        
        messageTextView
            .editable(false)
            .scrollEnabled(false)
            .superView(holderView)
            .backgroundColor(Yellow.alpha(0.1))
            .textContainerInset(UIEdgeInsets.zero)
            .font(UIFont.systemFont(ofSize: FontSize))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView
            .scrollEnabled(false)
            .registerCellClass(FYDImageDisplayCollectionViewCell.self)
            .superView(holderView)
            .backgroundColor(White)
        
        singleImageView
            .superView(holderView)
            .contentMode(UIViewContentMode.scaleAspectFill)
            .backgroundColor(Purple.alpha(0.3))
            .clipsToBounds(true)
        
        FangYuanDemo.BeginLayout {
            
            holderView
                .fy_edge(UIEdgeInsets(top: CellVerticalPadding, left: 0, bottom: 0, right: 0))
            
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
    
    func set(_ item:Item) {
        
        /// - Todo: 这里的传值写的不好
        
        self.item = item
        func setValues() {
            messageTextView.text = item.message
            nickNameLabel.text   = item.nickName
            switch item.imageURLs.count {
            case 0:
                singleImageView.isHidden = true
                imageCollectionView.isHidden = true
            case 1:
                singleImageView.kf.setImage(with: ImageResource(downloadURL: item.imageURLs.first!.URL))
                singleImageView.isHidden = false
                imageCollectionView.isHidden = true
            default:
                singleImageView.isHidden = true
                imageCollectionView.isHidden = false
            }
            
            if item.imageURLs.count > 1 {
                imageCollectionView.reloadData()
            }
        }
        
        DispatchQueue.main.async { 
            setValues()
        }
    
        /// - Todo: 这个方法走了两次，没有必要的！
        layoutHorizontally()
        _ = FYDComplexTableViewCell.layoutVerticallyAndComputeDisplayHeight(item, layoutCell: self)
    }
    
    func layoutHorizontally() {
        deleteButton.fy_width(item.isMine ? 100 : 0)
        var nickNameDisplayWidth : CGFloat
        if let cachedWidth = item.nickNameDisplayWidthCache {
            nickNameDisplayWidth = cachedWidth
        } else {
            let maxCGFloat = CGFloat(MAXFLOAT)
            nickNameDisplayWidth = (item.nickName as NSString).boundingRect(with: maxCGFloat.size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:nickNameLabel.font], context: nil).size.width
            item.nickNameDisplayWidthCache = nickNameDisplayWidth
        }
        nickNameLabel.fy_width(nickNameDisplayWidth)
    }
    
    class func layoutVerticallyAndComputeDisplayHeight(_ item:Item, layoutCell cell:FYDComplexTableViewCell?) -> CGFloat {
        
        var displayHeight : CGFloat = 0
        
        displayHeight += 5
        //  Height for display avatar, nickname and other info
        displayHeight += 40
        displayHeight += 3
        
        let messageDisplayHeight = calculateMessageDisplayHeightFor(item)
        if messageDisplayHeight != 0 {
            displayHeight += messageDisplayHeight
            displayHeight += 3
        }
        
        let imageDisplayHeight = calculateImageDispalyHeightFor(item)
        displayHeight += imageDisplayHeight
        
        displayHeight += 5
        displayHeight += CellVerticalPadding
        
        if let cell = cell {
            cell.messageTextView.fy_height(messageDisplayHeight)
            cell.singleImageView.fy_height(imageDisplayHeight)
            cell.imageCollectionView.fy_height(imageDisplayHeight)
        }
        
        return displayHeight
    }
    
    class func calculateMessageDisplayHeightFor(_ item:Item) -> CGFloat {
        var messageDisplayHeight : CGFloat
        if let cachedHeight = item.messageDisplayHeightCache {
            messageDisplayHeight = cachedHeight
        } else {
            messageDisplayHeight = (item.message as NSString).boundingRect(with: CGSize(width: ScreenWidth - 5.double, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: FontSize)], context: nil).size.height
            item.messageDisplayHeightCache = messageDisplayHeight
        }
        return messageDisplayHeight
    }
    
    class func calculateImageDispalyHeightFor(_ item:Item) -> CGFloat {
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
        return imagesDisplayHeight
    }

}

// MARK: - UICollectionViewDataSource
extension FYDComplexTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(FYDImageDisplayCollectionViewCell.self, indexPath: indexPath)
        cell.backgroundColor(Purple.alpha(0.1))
        if (indexPath as NSIndexPath).row < item.imageURLs.count {
            /// - Todo: Crash: Index out of range
            cell.imageView.kf.setImage(with: ImageResource(downloadURL: item.imageURLs[indexPath.row].URL))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let item = item else {
            return 0
        }
        return item.imageURLs.count > 1 ? item.imageURLs.count : 0
    }
}

// MARK: - UICollectionViewDelegate
extension FYDComplexTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FYDComplexTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = item else {
            return CGSize.zero
        }
        switch item.imageURLs.count {
        case 0, 1:
            return CGSize.zero
        case 2, 4:
            return CGSize(width: ScreenWidth / 2 - 0.5, height: ScreenWidth / 2 - 0.5)
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
            .contentMode(UIViewContentMode.scaleAspectFill)
            .clipsToBounds(true)
        
        FangYuanDemo.BeginLayout { 
            imageView
                .fy_edge(UIEdgeInsets.zero)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
