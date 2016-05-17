
import UIKit
import FangYuan
import Halo

class FYDListViewController: UIViewController {
    
    let demoMaps: [Dictionary<String, UIViewController.Type>] = [
        ["在 UIViewController 中使用" : FYDDemoViewController.self],
        ["chainTop/Bottom/Left/Right 属性调用" : FYDChainViewController.self],
        ["动画" : FYDAnimationViewController.self],
        ["在 UITableViewCell 中使用" : FYDDemoTableViewController.self],
        ["⚠️Unfinish 矩形拖拽" : FYDRectViewController.self],
        ["⚠️Unfinish 在复杂的 UITableViewCell 中使用" : FYDComplexTableViewController.self],
    ]

    lazy var tableView = UITableView(frame: ScreenBounds, style: .Plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor(White)
        tableView
            .registerCellClass(UITableViewCell)
            .dataSourceAndDelegate(self)
            .tableFooterViewAdded()
            .superView(view)
            .fy_edge(UIEdgeInsetsZero)
    }
}

// MARK: - UITableViewDelegate
extension FYDListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pair = demoMaps[indexPath.row].first!
        push(pair.1.init().backgroundColor(White).title(pair.0))
    }
}

// MARK: - UITableViewDataSource
extension FYDListViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView
            .dequeueCell(UITableViewCell)
            .selectionStyle(.None)
            .accessoryType(.DisclosureIndicator)
            .text(demoMaps[indexPath.row].keys.first!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoMaps.count
    }
}
