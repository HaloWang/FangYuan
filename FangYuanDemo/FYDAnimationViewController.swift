//
//  FYDAnimationViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/10.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import Halo
import FangYuan

class FYDAnimationViewController: UIViewController {
    
    lazy var demoView = UIView()
    lazy var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoView
            .superView(view)
            .backgroundColor(Red.alpha(0.5))
        
        button
            .superView(view)
            .backgroundColor(HEX("44cc44"))
            .title("Animation")
            .titleColor(White)
            .target(self, upInsideAction: #selector(FYDAnimationViewController.animate))
        
        FangYuanDemo.BeginLayout { 
            demoView
                .fy_left(20)
                .fy_right(20)
                .fy_top(100)
                .fy_height(100)
            
            button
                .fy_left(25)
                .fy_right(25)
                .fy_bottom(20)
                .fy_height(60)
            
        }
    }
    
    func animate() {
        let newY : CGFloat = self.demoView.frame.origin.y == 100 ? 200 : 100
        UIView.animateWithDuration(0.25) {
            self.demoView.fy_top(newY).toAnimation()
        }
    }

}
