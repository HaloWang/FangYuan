
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
    
    static let codeBackgroundColor = HEX("222222")
    static let codeColor = HEX("BEBEBE")
    
    static let displayHeight = 20.f
    
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
        
        backgroundColor(FYDCodeTableViewCell.codeBackgroundColor)
        
        codeLabel
            .superView(self)
            .backgroundColor(FYDCodeTableViewCell.codeBackgroundColor)
            .textColor(FYDCodeTableViewCell.codeColor)
            .font(UIFont(name: "Monaco", size: 12)!)
        
        codeLabel
            .fy_edge(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
