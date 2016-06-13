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

/// - TODO: Holder
/// - TODO: Line
/// - TODO: Click
class FYDRectViewController: UIViewController {

    let rectView       = UILabel()
    let holder         = UIView()
    let topLeftPan     = UIView()
    let bottomRightPan = UIView()
    let codeList       = UITableView()
    
    class ValueStore {
        var top    = 0.f
        var height = 0.f
        var bottom = 0.f
        var left   = 0.f
        var width  = 0.f
        var right  = 0.f
        var vs = ValidStore()
    }
    
    class ValidStore {
        var top    = true
        var bottom = true
        var left   = true
        var right  = true
        var height = false
        var width  = false
    }
    
    let vs = ValueStore()

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
            .superView(holder)
            .backgroundColor(UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1))
            .text("rectView")
            .textAlignment(.Center)
            .userInteractionEnabled(true)
        
        holder
            .superView(view)
        
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
                .fy_top(64)
                .fy_height(FYDCodeTableViewCell.displayHeight * 7)
            
            holder
                .fy_edge(UIEdgeInsets(top: codeList.chainBottom, left: 0, bottom: 0, right: 0))
            
            bottomRightPan
                .fy_bottom(0)
                .fy_height(40)
                .fy_right(0)
                .fy_width(40)
            
            topLeftPan
                .fy_top(0)
                .fy_height(40)
                .fy_left(0)
                .fy_width(40)
        }
        
        rectView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        rectView.removeObserver(self, forKeyPath: "frame")
    }
}

extension FYDRectViewController {
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let _frame = rectView.frame
        vs.left    = _frame.x
        vs.top     = _frame.y
        vs.height  = _frame.height
        vs.width   = _frame.width
        vs.bottom  = view.height - vs.top - vs.height
        vs.right   = view.width - vs.left - vs.width
        codeList.reloadData()
    }
    
    func topLeftPanTouched(sender: UIPanGestureRecognizer) {
        let t = sender.translationInView(holder)
        switch sender.state {
        case .Began:
            storeLeftTop = rectView.origin
            storeRightBottom = CGPoint(x: holder.width - rectView.x - rectView.width,
                                       y: holder.height - rectView.y - rectView.height)
            rectView
                .fy_bottom(storeRightBottom.y)
                .fy_right(storeRightBottom.x)
        case .Changed:
            let newOrigin = CGPoint(x: storeLeftTop.x + t.x, y: storeLeftTop.y + t.y)
            rectView
                .fy_origin(newOrigin)
                .toAnimation()
        case .Ended:
            if rectView.x < 20 {
                rectView.fy_left(20)
            }
            if rectView.y < 10 {
                rectView.fy_top(10)
            }
            AnimateWithDuration(0.15) {
                // TODO: JUMP?
                rectView.toAnimation()
            }
        default:
            break
        }
    }

    func bottomRightPanTouched(sender: UIPanGestureRecognizer) {
        let t = sender.translationInView(holder)
        switch sender.state {
        case .Began:
            storeLeftTop = rectView.origin
            rectView.fy_origin(storeLeftTop)
            storeWidthHeight = rectView.size
        case .Changed:
            let newSize = CGSize(width: storeWidthHeight.width + t.x, height: storeWidthHeight.height + t.y)
            rectView
                .fy_size(newSize)
                .toAnimation()
        case .Ended:
            if rectView.x + rectView.width + 10 > rectView.superview!.width {
                rectView
                    .fy_left(storeLeftTop.x)
                    .fy_right(10)
            }
            if rectView.y + rectView.height + 10 > rectView.superview!.height {
                rectView
                    .fy_top(storeLeftTop.y)
                    .fy_bottom(10)
            }
            AnimateWithDuration(0.15) {
                rectView.toAnimation()
            }
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
            cell.code = "        .fy_top(\(vs.top))"
        case 2:
            cell.code = "        .fy_bottom(\(vs.bottom))"
        case 3:
            cell.code = "        .fy_left(\(vs.left))"
        case 4:
            cell.code = "        .fy_right(\(vs.right))"
        case 5:
            cell.code = "        .fy_width(\(vs.width))"
        case 6:
            cell.code = "        .fy_height(\(vs.height))"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

