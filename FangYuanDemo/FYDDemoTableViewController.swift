//
//  FYDDemoTableViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/6.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan
import KMCGeigerCounter

class FYDDemoTableViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
    lazy var heightArray = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(FYDemoCell.self, forCellReuseIdentifier: NSStringFromClass(FYDemoCell))
        tableView.tableFooterView = UIView()
        
        dispatch_async(dispatch_get_main_queue()) { 
            for _ in 0...999 {
                self.heightArray.append(105 + CGFloat(arc4random() % 60))
            }
            self.tableView.reloadData()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "帧率监视", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FYDDemoTableViewController.changeStatus))

    }
    
    func changeStatus() {
        KMCGeigerCounter.sharedGeigerCounter().enabled = !KMCGeigerCounter.sharedGeigerCounter().enabled
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: KMCGeigerCounter.sharedGeigerCounter().enabled ? "关闭帧率监视" : "开启帧率监视", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FYDDemoTableViewController.changeStatus))
    }
    
}

// MARK: - UITableViewDelegate
extension FYDDemoTableViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105 + 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightArray[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension FYDDemoTableViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FYDemoCell)) as! FYDemoCell
        let _row = indexPath.row
        cell.nickNameLabel.text = "昵称 \(_row)"
        cell.timeLabel.text = "时间 \(_row)"
        cell.messageTextView.text = "文本内容 文本内容 文本内容 文本内容 文本内容 文本内容 文本内容 文本内容 文本内容 "
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heightArray.count
    }
}


// MARK: - FYDemoCell
class FYDemoCell: UITableViewCell {
    
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
        likeButton.setTitle("♥️", forState: UIControlState.Normal)
        likeButton.layer.cornerRadius = 3
        likeButton.layer.borderWidth = 0.5
        likeButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        //  ⚠️ 注意这一步是必须的，否则下面的代码在调用 superview.frame.size.width 时取到的是 320
        frame.size.width = UIScreen.mainScreen().bounds.size.width
        
        //  头像的位置相对固定
        avatarImageView
            .fy_left(5)
            .fy_top(5)
            .fy_width(_avatarImageViewRadius * 2)
            .fy_height(_avatarImageViewRadius * 2)
        
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
        //  但是高度可能是动态的，所以在这里我们
        messageTextView
            .fy_left(avatarImageView.chainRight + 5)
            .fy_top(timeLabel.chainBottom + 5)
            .fy_right(15)
        
        likeButton
            .fy_right(15)
            .fy_width(60)
            .fy_height(20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageTextView.fy_bottom(25)
        likeButton.fy_bottom(2.5)
    }
}
