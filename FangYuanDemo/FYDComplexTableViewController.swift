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
    
    let tableView = UITableView(frame: ScreenBounds, style: .plain)
    
    var data = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = FYDComplexDataSource.randomData
        
        tableView
            .dataSourceAndDelegate(self)
            .separatorStyle(.none)
            .registerCellClass(FYDComplexTableViewCell.self)
            .superView(view)
            .backgroundColor(HEX("f1f1f1"))
    }
}

// MARK: - UITableViewDelegate
extension FYDComplexTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data[(indexPath as NSIndexPath).row]
        return FYDComplexTableViewCell.layoutVerticallyAndComputeDisplayHeight(item, layoutCell: nil)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - UITableViewDataSource
extension FYDComplexTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueCell(FYDComplexTableViewCell.self)
            .selectionStyle(.none)
        
        cell.set(data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
