
//
//  FYDCodeTableViewCell.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/13.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan
import Halo

class FYDCodeTableViewCell: UITableViewCell {
    
    static let displayHeight = 30.f
    
    let codeLabel = UILabel()
    
    var code : String? {
        get {
            return codeLabel.text
        }
        set {
            codeLabel.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        codeLabel
            .superView(self)
        
        codeLabel
            .fy_edge(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
