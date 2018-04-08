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

private var storeLeftTop     = CGPoint.zero
private var storeWidthHeight = CGSize.zero
private var storeRightBottom = CGPoint.zero

/// - Todo: Holder
/// - Todo: Line
/// - Todo: Click
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
            .registerCellClass(FYDCodeTableViewCell.self)
            .separatorStyle(.none)
            .superView(view)
            .backgroundColor(FYDCodeTableViewCell.codeBackgroundColor)
        
        rectView
            .superView(holder)
            .backgroundColor(UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1))
            .text("rectView")
            .textAlignment(.center)
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
        
        rectView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    deinit {
        rectView.removeObserver(self, forKeyPath: "frame")
    }
}

extension FYDRectViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let _frame = rectView.frame
        vs.left    = _frame.x
        vs.top     = _frame.y
        vs.height  = _frame.height
        vs.width   = _frame.width
        vs.bottom  = view.height - vs.top - vs.height
        vs.right   = view.width - vs.left - vs.width
        codeList.reloadData()
    }
    
    @objc func topLeftPanTouched(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: holder)
        switch sender.state {
        case .began:
            storeLeftTop = rectView.origin
            storeRightBottom = CGPoint(x: holder.width - rectView.x - rectView.width,
                                       y: holder.height - rectView.y - rectView.height)
            rectView
                .fy_bottom(storeRightBottom.y)
                .fy_right(storeRightBottom.x)
        case .changed:
            let newOrigin = CGPoint(x: storeLeftTop.x + t.x, y: storeLeftTop.y + t.y)
            rectView
                .fy_origin(newOrigin)
                .toAnimation()
        case .ended:
            if rectView.x < 20 {
                rectView.fy_left(20)
            }
            if rectView.y < 10 {
                rectView.fy_top(10)
            }
            rectView.toAnimation()
        default:
            break
        }
    }

    @objc func bottomRightPanTouched(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: holder)
        switch sender.state {
        case .began:
            storeLeftTop = rectView.origin
            rectView.fy_origin(storeLeftTop)
            storeWidthHeight = rectView.size
        case .changed:
            let newSize = CGSize(width: storeWidthHeight.width + t.x, height: storeWidthHeight.height + t.y)
            rectView
                .fy_size(newSize)
                .toAnimation()
        case .ended:
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
            rectView.toAnimation()
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension FYDRectViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).row {
        case 1:
            EnableConstraintHolder.pushConstraintAt(.top)
        case 2:
            EnableConstraintHolder.pushConstraintAt(.bottom)
        case 3:
            EnableConstraintHolder.pushConstraintAt(.left)
        case 4:
            EnableConstraintHolder.pushConstraintAt(.right)
        case 5:
            EnableConstraintHolder.pushConstraintAt(.width)
        case 6:
            EnableConstraintHolder.pushConstraintAt(.height)
        default:
            break
        }
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FYDCodeTableViewCell.displayHeight
    }
}

private extension String {
    func indentation(_ indentation:Int) -> String {
        var newString = self
        for _ in 0..<indentation {
            newString = "    " + newString
        }
        return newString
    }
}

// MARK: - UITableViewDataSource
extension FYDRectViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FYDCodeTableViewCell.self).selectionStyle(.none)
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.code = "rectView".indentation(1)
        case 1:
            cell.code = ".fy_top(\(vs.top))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.top)
        case 2:
            cell.code = ".fy_bottom(\(vs.bottom))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.bottom)
        case 3:
            cell.code = ".fy_left(\(vs.left))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.left)
        case 4:
            cell.code = ".fy_right(\(vs.right))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.right)
        case 5:
            cell.code = ".fy_width(\(vs.width))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.width)
        case 6:
            cell.code = ".fy_height(\(vs.height))".indentation(2)
            cell.commented = !EnableConstraintHolder.validAt(.height)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

