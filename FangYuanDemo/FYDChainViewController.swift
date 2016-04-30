
import UIKit
import Halo

class FYDChainViewController: UIViewController {

    let baseView        = UILabel()
    let chainBottomView = UILabel()
    let chainLeftView   = UILabel()
    let chainTopView    = UILabel()
    let chainRightView  = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        baseView
            .superView(view)
            .backgroundColor(RGB(255, 200, 200))
            .text("baseView")
            .textAlignmentCenter()

        chainBottomView
            .text("chainBottomView")
            .textAlignmentCenter()
            .backgroundColor(RGB(200, 255, 200))
            .superView(view)
        
        chainLeftView
            .text("chainLeftView")
            .textAlignmentCenter()
            .backgroundColor(RGB(200, 255, 200))
            .superView(view)
        
        chainTopView
            .text("chainTopView")
            .textAlignmentCenter()
            .backgroundColor(RGB(200, 255, 200))
            .superView(view)
        
        chainRightView
            .text("chainRightView")
            .textAlignmentCenter()
            .backgroundColor(RGB(200, 255, 200))
            .superView(view)

        chainBottomView
            .fy_top(baseView.chainBottom + 100)
            .fy_left(50)
            .fy_right(50)
            .fy_height(100)
        
        chainLeftView
            .fy_top(250)
            .fy_right(baseView.chainLeft + 25)
            .fy_left(5)
            .fy_bottom(250)
        
        baseView
            .fy_top(250 + NavigationBarHeight)
            .fy_left(140)
            .fy_right(140)
            .fy_height(50)
        
        chainTopView
            .fy_top(100)
            .fy_right(100)
            .fy_left(100)
            .fy_bottom(baseView.chainTop + 100)
        
        chainRightView
            .fy_top(100)
            .fy_right(10)
            .fy_left(baseView.chainRight + 50)
            .fy_bottom(baseView.chainTop)
        
    }
}
