//
//  FYDDemoViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/6.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan

class FYDDemoViewController: UIViewController {
    
    let dv0 = UILabel()
    let dv1 = UILabel()
    let dv2 = UILabel()
    let dv3 = UILabel()
    let dv4 = UILabel()
    
    var demoSubviews : [UILabel] {
        return [dv0, dv1, dv2, dv3, dv4]
    }
    
    override func loadView() {
        super.loadView()
        //  设置背景颜色
        dv0.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        dv1.backgroundColor = UIColor(red: 0.5, green: 0.75, blue: 1, alpha: 1)
        dv2.backgroundColor = UIColor(red: 0.9, green: 1, blue: 0.4, alpha: 1)
        dv3.backgroundColor = UIColor(red: 0.4, green: 1, blue: 0.4, alpha: 1)
        dv4.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 1, alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<demoSubviews.count {
            let demoSubview = self.demoSubviews[i]
            demoSubview.text = "dv\(i)"
            demoSubview.textAlignment = .Center
            self.view.addSubview(demoSubview)
        }
        
        //  按住 Alt + 点击方法名来查看方法说明
        
        dv0
            .fy_top(50)
            .fy_left(25)
            .fy_width(50)
            .fy_height(80)

        dv1
            .fy_bottom(0)
            .fy_left(0)
            .fy_right(0)
            .fy_height(49)
        dv2
            .fy_right(0)
            .fy_width(50)
            .fy_height(100)
            .fy_top(200)
        
        //  同时设定 dv3 四个边的约束
        
        //  这里使用了 chainLeft
        //  意义为：使 dv3 的右边距离 dv2 的左边距离为 5
        
        //  这里使用了 chainTop
        //  意义为：使 dv3 的底部距离 dv1 的顶部距离为 10
        
        let _padding : CGFloat = 100
        dv3
            .fy_edge(UIEdgeInsets(top: 64 + _padding, left: 100, bottom: dv1.chainTop + 10, right: dv2.chainLeft + 5))
        
        
        //  ⚠️但是，此时你无法使用 dv4.chainBottom
        //  因为 dv4 还没有被设置约束
        //  dv4.chainBottom = 0
        //  囧rz
        //  dv3.fy_top(dv4.chainBottom + 4)
        
        //  ✅ 你可以在使用 dv4.chainBottom 之前设定好 dv4 的约束
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //  你也可以在 viewWillLayoutSubviews 中使用该方法
        
        dv4
            .fy_top(100)
            .fy_left(0)
            .fy_right(0)
            .fy_height(50)
    }
    
}
