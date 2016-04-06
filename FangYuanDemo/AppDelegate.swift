//
//  AppDelegate.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/2.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import Halo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        
        window = UIWindow(frame: ScreenBounds)
        window?.rootViewController = FYDViewController().title("方圆").navigationed
        window?.makeKeyAndVisible()
        
        return true
    }


}

