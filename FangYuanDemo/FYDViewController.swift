
import UIKit
import FangYuan
import Halo

class FYDViewController: UIViewController {
    
    let demoMaps: [Dictionary<String, UIViewController.Type>] = [
        ["在 UIViewController 中使用" : FYDDemoViewController.self],
        ["chainTop/Bottom/Left/Right 属性调用" : FYDChainViewController.self],
        ["在 UITableViewCell 中使用" : FYDDemoTableViewController.self],
        ["Animation" : FYDAnimationViewController.self],
        ["⚠️Unfinish 矩形拖拽" : FYDRectViewController.self],
        ["⚠️Unfinish 观察代码" : FYDReactiveCodeViewController.self],
        ["⚠️Unfinish 对比 SnapKit" : FYDVSAutoLayoutViewController.self],
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
extension FYDViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pair = demoMaps[indexPath.row].first!
        push(pair.1.init().backgroundColor(White).title(pair.0))
    }
}

// MARK: - UITableViewDataSource
extension FYDViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell).selectionStyle(.None).accessoryType(.DisclosureIndicator)
        cell.text(demoMaps[indexPath.row].keys.first!)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoMaps.count
    }
}
