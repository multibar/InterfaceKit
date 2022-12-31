import UIKit

extension CALayer {
    public func corner(radius: CGFloat, curve: Curve = .continuous) {
        cornerRadius = radius
        cornerCurve = curve.value
    }
    public func border(width: CGFloat) {
        borderWidth = width
    }
    public func border(color: UIColor?) {
        borderColor = color?.cgColor
    }
}

extension CALayer {
    public var curve: Curve {
        get {
            switch cornerCurve {
            case .circular  : return .circular
            case .continuous: return .continuous
            default: return .circular
            }
        }
        set {
            cornerCurve = newValue.value
        }
    }
}

extension CALayer {
    public enum Curve {
        case circular
        case continuous
        
        public var value: CALayerCornerCurve {
            switch self {
            case .circular  : return .circular
            case .continuous: return .continuous
            }
        }
    }
}
