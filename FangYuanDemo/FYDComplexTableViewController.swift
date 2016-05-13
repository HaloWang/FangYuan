//
//  FYDComplexTableViewController.swift
//  FangYuanDemo
//
//  Created by 王策 on 16/5/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import UIKit
import Halo

class FYDComplexTableViewController: UIViewController {
    
    let tableView = UITableView(frame: ScreenBounds, style: .Plain)
    
    var data = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = FYDComplexDataSource.requestData()
        
        tableView
            .dataSourceAndDelegate(self)
            .registerCellClass(FYDComplexTableViewCell)
            .superView(view)
    }
    
}

// MARK: - UITableViewDelegate
extension FYDComplexTableViewController : UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension FYDComplexTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueCell(FYDComplexTableViewCell)
            .selectionStyle(.None)
        cell.setWith(data[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
