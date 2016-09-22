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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: ScreenBounds)
        window?.rootViewController = FYDListViewController().title("方圆").navigationed
        window?.makeKeyAndVisible()

        return true
    }


}
