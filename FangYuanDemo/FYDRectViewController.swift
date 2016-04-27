//
//  FYDRectViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/27.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan

class FYDRectViewController: UIViewController {

    let rectView = UIView()
    let panView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rectView)
        rectView.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
        rectView.frame = CGRect(x: 50, y: 200, width: 200, height: 200)

        rectView.addSubview(view)
        panView.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0.1, alpha: 1)
        panView.fy_bottom(-10).fy_height(20).fy_right(-10).fy_width(20)
        panView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(FYDRectViewController.pan(_:))))

    }

    func pan(sender: UIPanGestureRecognizer) {
        print(sender.translationInView(view))
    }

}
