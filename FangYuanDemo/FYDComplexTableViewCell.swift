//
//  FYDComplexTableViewCell.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit

class FYDComplexTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let nickNameLabel   = UILabel()
    let messageTextView = UITextView()
    let commentsList    = UITableView(frame: CGRectZero, style: .Plain)
    let deleteButton    = UIButton()
    let likeButton      = UIButton()
    var imageCollectionView : UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
