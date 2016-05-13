//
//  FYDRectViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/27.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan
import Halo

class FYDRectViewController: UIViewController {

    let rectView = UILabel()
    let topLeftPan = UIView()
    let bottomRightPan = UIView()
    let codeList = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets(false)
        
        codeList
            .dataSourceAndDelegate(self)
            .registerCellClass(FYDCodeTableViewCell)
            .superView(view)
        
        codeList
            .fy_left(0)
            .fy_right(0)
            .fy_bottom(0)
            .fy_height(FYDCodeTableViewCell.displayHeight * 7)

        rectView
            .superView(view)
            .backgroundColor(UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1))
            .text("rectView")
            .textAlignment(.Center)
        
        rectView.frame = CGRect(x: 50, y: 200, width: 200, height: 200)
        
        bottomRightPan
            .superView(rectView)
            .backgroundColor(UIColor(red: 1, green: 0.7, blue: 0.1, alpha: 1))
        bottomRightPan
            .fy_bottom(-10)
            .fy_height(20)
            .fy_right(-10)
            .fy_width(20)
        
        topLeftPan
            .superView(rectView)
            .backgroundColor(UIColor(red: 1, green: 0.7, blue: 0.1, alpha: 1))
        topLeftPan
            .fy_top(-10)
            .fy_height(20)
            .fy_left(-10)
            .fy_width(20)
    }

    func pan(sender: UIPanGestureRecognizer) {
        print(sender.translationInView(view))
    }
}

// MARK: - UITableViewDelegate
extension FYDRectViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FYDCodeTableViewCell.displayHeight
    }
}

// MARK: - UITableViewDataSource
extension FYDRectViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FYDCodeTableViewCell).selectionStyle(.None)
        
        switch indexPath.row {
        case 0:
            cell.code = "rectView"
        case 1:
            cell.code = "    .fy_top()"
        case 2:
            cell.code = "    .fy_top()"
        case 3:
            cell.code = "    .fy_top()"
        case 4:
            cell.code = "    .fy_top()"
        case 5:
            cell.code = "    .fy_top()"
        case 6:
            cell.code = "    .fy_top()"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

