
import Foundation

/// This class is used to provide FangYuan.Ruler's logic
///
/// - Warning: Only available in demo codes
public class EnableConstraintHolder {
    
    public enum Section {
        case Left
        case Right
        case Width
        case Top
        case Bottom
        case Height
    }
    
    private static let holderView = UIView()
    
    public static var validSections = [Section]()
    
    public class func validAt(section:Section) -> Bool {
        for _section in validSections {
            if section == _section {
                return true
            }
        }
        return false
    }
    
    public class func pushConstraintAt(section: EnableConstraintHolder.Section) {
        
        var sections = [Section]()
        
        let rx = holderView.rulerX
        let ry = holderView.rulerY
        
        switch section {
        case .Bottom:
            ry.c = 0
        case .Height:
            ry.b = 0
        case .Top:
            ry.a = 0
        case .Left:
            rx.a = 0
        case .Width:
            rx.b = 0
        case .Right:
            rx.c = 0
        }
        
        if rx.a != nil {
            sections.append(.Left)
        }
        
        if rx.b != nil {
            sections.append(.Width)
        }
        
        if rx.c != nil {
            sections.append(.Right)
        }
        
        if ry.a != nil {
            sections.append(.Top)
        }
        
        if ry.b != nil {
            sections.append(.Height)
        }
        
        if ry.c != nil {
            sections.append(.Bottom)
        }
        
        validSections = sections
    }
    
    public class func randomSections() {
        
    }
    
    public class func clearSections() {
        
    }
}
