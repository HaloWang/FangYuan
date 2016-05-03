
//  ✅ FYDDemoTableViewController
//  这个视图控制器中简单的演示了如何通过 FangYuan 为 UITableViewCell 布局
//  请大家主要查看 FYDemoCell 中的代码

import UIKit
import FangYuan
import KMCGeigerCounter

class FYDDemoTableViewController: UIViewController {

    lazy var tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
    lazy var heightArray = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(FYDDemoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FYDDemoTableViewCell))
        tableView.tableFooterView = UIView()

        dispatch_async(dispatch_get_main_queue()) {
            for _ in 0...99 {
                self.heightArray.append(75 + CGFloat(arc4random() % 200))
            }
            self.tableView.reloadData()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "帧率监视", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FYDDemoTableViewController.changeStatus))

    }

    func changeStatus() {
        KMCGeigerCounter.sharedGeigerCounter().enabled = !KMCGeigerCounter.sharedGeigerCounter().enabled
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: KMCGeigerCounter.sharedGeigerCounter().enabled ? "关闭帧率监视" : "开启帧率监视", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FYDDemoTableViewController.changeStatus))
    }

}

// MARK: - UITableViewDelegate
extension FYDDemoTableViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105 + 30
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightArray[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension FYDDemoTableViewController : UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FYDDemoTableViewCell)) as! FYDDemoTableViewCell
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heightArray.count
    }
}
