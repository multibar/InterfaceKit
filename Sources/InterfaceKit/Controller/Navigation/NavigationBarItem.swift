import UIKit

extension NavigationController.Bar {
    public enum Item {
        case back(attributes: Attributes)
        case icon(UIImage?, attributes: Attributes, position: Position, width: CGFloat? = nil, highlightable: Bool = true, action: () -> Void = {})
        case view(UIView, attributes: Attributes, position: Position, width: CGFloat? = nil, highlightable: Bool = true, action: () -> Void = {})
        
        public var attributes: Attributes {
            switch self {
            case .back(let attributes),
                 .icon(_, let attributes, _, _, _, _),
                 .view(_, let attributes, _, _, _, _):
                return attributes
            }
        }
        
        public var position: Position {
            switch self {
            case .icon(_, _, let position, _, _, _),
                 .view(_, _, let position, _, _, _):
                return position
            case .back:
                return .left
            }
        }
        public var action: (() -> Void)? {
            switch self {
            case .icon(_, _, _, _, _, let action),
                 .view(_, _, _, _, _, let action):
                return action
            default:
                return nil
            }
        }
        public var back: Bool {
            switch self {
            case .back: return true
            default   : return false
            }
        }
    }
}

extension NavigationController.Bar.Item {
    public enum Position {
        case left, middle, right
    }
}
