//
//  FYDDemoTableViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/4/6.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import FangYuan

class FYDDemoTableViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(FYDemoCell.self, forCellReuseIdentifier: NSStringFromClass(FYDemoCell))
    }
}

// MARK: - UITableViewDelegate
extension FYDDemoTableViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource
extension FYDDemoTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FYDemoCell)) as! FYDemoCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}


// MARK: - FYDemoCell
class FYDemoCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
