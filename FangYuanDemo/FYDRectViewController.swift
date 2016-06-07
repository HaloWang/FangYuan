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

private var storeLeftTop     = CGPointZero
private var storeWidthHeight = CGSizeZero
private var storeRightBottom = CGPointZero

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
            .separatorStyle(.None)
            .superView(view)
            .backgroundColor(FYDCodeTableViewCell.codeBackgroundColor)
        
        rectView
            .superView(view)
            .backgroundColor(UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1))
            .text("rectView")
            .textAlignment(.Center)
            .userInteractionEnabled(true)
        
        bottomRightPan
            .superView(rectView)
            .backgroundColor(UIColor(red: 1, green: 0.7, blue: 0.1, alpha: 1))
            .userInteractionEnabled(true)
        
        bottomRightPan.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(FYDRectViewController.bottomRightPanTouched(_:))))
        
        topLeftPan
            .superView(rectView)
            .backgroundColor(UIColor(red: 1, green: 0.7, blue: 0.1, alpha: 1))
        
        topLeftPan.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(FYDRectViewController.topLeftPanTouched(_:))))
        
        FangYuanDemo.BeginLayout {
            
            rectView
                .fy_frame(CGRect(x: 50, y: 200, width: 200, height: 200))
            
            codeList
                .fy_left(0)
                .fy_right(0)
                .fy_bottom(0)
                .fy_height(FYDCodeTableViewCell.displayHeight * 7)
            
            bottomRightPan
                .fy_bottom(0)
                .fy_height(20)
                .fy_right(0)
                .fy_width(20)
            
            topLeftPan
                .fy_top(0)
                .fy_height(20)
                .fy_left(0)
                .fy_width(20)
        }
    }
}

extension FYDRectViewController {
    func bottomRightPanTouched(sender: UIPanGestureRecognizer) {
        let t = sender.translationInView(view)
        switch sender.state {
        case .Began:
            storeWidthHeight = rectView.frame.size
        case .Changed:
            let newSize = CGSize(width: storeWidthHeight.width + t.x, height: storeWidthHeight.height + t.y)
            rectView.fy_size(newSize).toAnimation()
        default:
            break
        }
    }
    
    func topLeftPanTouched(sender: UIPanGestureRecognizer) {
        let t = sender.translationInView(view)
        switch sender.state {
        case .Began:
            storeLeftTop = rectView.frame.origin
            storeRightBottom = CGPoint(x: view.frame.size.width - rectView.frame.origin.x - rectView.frame.size.width,
                                       y: view.frame.size.height - rectView.frame.origin.y - rectView.frame.size.height)
        case .Changed:
            let newOrigin = CGPoint(x: storeLeftTop.x + t.x, y: storeLeftTop.y + t.y)
            rectView.fy_edge(UIEdgeInsets(top: newOrigin.y, left: newOrigin.x, bottom: storeRightBottom.x, right: storeRightBottom.y)).toAnimation()
        default:
            break
        }
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
            cell.code = "    rectView"
        case 1:
            cell.code = "        .fy_top()"
        case 2:
            cell.code = "        .fy_bottom()"
        case 3:
            cell.code = "        .fy_left()"
        case 4:
            cell.code = "        .fy_right()"
        case 5:
            cell.code = "        .fy_width()"
        case 6:
            cell.code = "        .fy_height()"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

