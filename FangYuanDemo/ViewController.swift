
import UIKit
import FangYuan

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let demoView = UIView()
        demoView.backgroundColor = UIColor.redColor()
        view.addSubview(demoView)
        
        demoView
            .fy_top(60)
            .fy_right(60)
            .fy_left(60)
            .fy_bottom(120)
    }
}

