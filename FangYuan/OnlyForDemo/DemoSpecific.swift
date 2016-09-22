
import Foundation

/// This class is used to provide FangYuan.Ruler's logic
///
/// - Warning: Only available in demo codes
open class EnableConstraintHolder {
    
    public enum Section {
        case left
        case right
        case width
        case top
        case bottom
        case height
    }
    
    fileprivate static let holderView = UIView()
    
    open static var validSections = [Section]()
    
    open class func validAt(_ section:Section) -> Bool {
        for _section in validSections {
            if section == _section {
                return true
            }
        }
        return false
    }
    
    open class func pushConstraintAt(_ section: EnableConstraintHolder.Section) {
        
        var sections = [Section]()
        
        let rx = holderView.rulerX
        let ry = holderView.rulerY
        
        switch section {
        case .bottom:
            ry.c = 0
        case .height:
            ry.b = 0
        case .top:
            ry.a = 0
        case .left:
            rx.a = 0
        case .width:
            rx.b = 0
        case .right:
            rx.c = 0
        }
        
        if rx.a != nil {
            sections.append(.left)
        }
        
        if rx.b != nil {
            sections.append(.width)
        }
        
        if rx.c != nil {
            sections.append(.right)
        }
        
        if ry.a != nil {
            sections.append(.top)
        }
        
        if ry.b != nil {
            sections.append(.height)
        }
        
        if ry.c != nil {
            sections.append(.bottom)
        }
        
        validSections = sections
    }
    
    open class func randomSections() {
        
    }
    
    open class func clearSections() {
        
    }
}
