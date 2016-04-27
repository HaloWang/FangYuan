
import UIKit
import FangYuan
import Halo

class FYDViewController: UIViewController {

    let titles = [
        "⚠️Unfinish 观察代码",
        "在 ViewController 中使用",
        "在 Cell 中使用",
        "⚠️Unfinish 对比 SnapKit"
    ]

    let vcs = [
        FYDReactiveCodeViewController.self,
        FYDDemoViewController.self,
        FYDDemoTableViewController.self,
        FYDVSAutoLayoutViewController.self
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

        tableView.tag = 111

    }

}

// MARK: - UITableViewDelegate
extension FYDViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cls = vcs[indexPath.row] as! UIViewController.Type
        push(cls.init().backgroundColor(White).title(titles[indexPath.row]))
    }
}

// MARK: - UITableViewDataSource
extension FYDViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell).selectionStyle(.None).accessoryType(.DisclosureIndicator)
        cell.text(titles[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
}
