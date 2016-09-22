
//  ✅ FYDDemoTableViewController
//  这个视图控制器中简单的演示了如何通过 FangYuan 为 UITableViewCell 布局
//  请大家主要查看 FYDemoCell 中的代码

import UIKit
import FangYuan

class FYDDemoTableViewController: UIViewController {

    lazy var tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    lazy var heightArray = [CGFloat]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        DispatchQueue.main.async {
            for _ in 0...99 {
                self.heightArray.append(75 + CGFloat(arc4random() % 200))
            }
            self.tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.tableFooterView = UIView()
        tableView.register(FYDDemoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FYDDemoTableViewCell.self))
    }
    
}

// MARK: - UITableViewDelegate
extension FYDDemoTableViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105 + 30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightArray[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UITableViewDataSource
extension FYDDemoTableViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FYDDemoTableViewCell.self)) as! FYDDemoTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heightArray.count
    }
}
