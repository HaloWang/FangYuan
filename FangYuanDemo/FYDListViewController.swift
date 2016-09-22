
import UIKit
import FangYuan
import Halo

class FYDListViewController: UIViewController {
    
    let demoMaps: [Dictionary<String, UIViewController.Type>] = [
        ["在 UIViewController 中使用" : FYDDemoViewController.self],
        ["chainTop/Bottom/Left/Right 属性调用" : FYDChainViewController.self],
        ["动画" : FYDAnimationViewController.self],
        ["在 UITableViewCell 中使用" : FYDDemoTableViewController.self],
        ["矩形拖拽".unfinish : FYDRectViewController.self],
        ["在复杂的 UITableViewCell 中使用" : FYDComplexTableViewController.self],
    ]

    lazy var tableView = UITableView(frame: ScreenBounds, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor(White)
        tableView
            .registerCellClass(UITableViewCell.self)
            .dataSourceAndDelegate(self)
            .tableFooterViewAdded()
            .superView(view)
            .fy_edge(UIEdgeInsets.zero)
    }
}

private extension String {
    var unfinish : String {
        return "⚠️Unfinish " + self
    }
}

// MARK: - UITableViewDelegate
extension FYDListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pair = demoMaps[(indexPath as NSIndexPath).row].first!
        push(pair.1.init().backgroundColor(White).title(pair.0))
    }
}

// MARK: - UITableViewDataSource
extension FYDListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView
            .dequeueCell(UITableViewCell.self)
            .selectionStyle(.none)
            .accessoryType(.disclosureIndicator)
            .text(demoMaps[indexPath.row].keys.first!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoMaps.count
    }
}
