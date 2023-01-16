import UIKit
import CoreKit

public struct Layout {
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first
    }
    public struct SafeArea {
        public static var top: CGFloat {
            let top = keyWindow?.safeAreaInsets.top ?? 0
            guard System.Device.island else { return top }
            return top == 59 ? 54 : top
        }
        public static var bottom: CGFloat {
            return keyWindow?.safeAreaInsets.bottom ?? 0
        }
        public static var left: CGFloat {
            return keyWindow?.safeAreaInsets.left ?? 0
        }
        public static var right: CGFloat {
            return keyWindow?.safeAreaInsets.right ?? 0
        }
        public static var insets: UIEdgeInsets {
            return keyWindow?.safeAreaInsets ?? .zero
        }
    }
}
extension UITraitCollection {
    public var horizontal: Size {
        if horizontalSizeClass == .regular {
            return .regular(limited: phone)
        } else if horizontalSizeClass == .compact && landscape && phone {
            return .regular(limited: true)
        } else {
            return .compact
        }
    }
    public var vertical: Size {
        switch verticalSizeClass {
        case .regular:
            return .regular(limited: userInterfaceIdiom == .phone)
        default:
            return .compact
        }
    }
    public var segmented: Bool {
        switch horizontal {
        case .regular:
            return true
        case .compact:
            return false
        }
    }
    public var portrait: Bool {
        return Layout.keyWindow?.bounds.width ?? UIScreen.main.bounds.width < Layout.keyWindow?.bounds.height ?? UIScreen.main.bounds.height
    }
    public var landscape: Bool {
        return Layout.keyWindow?.bounds.width ?? UIScreen.main.bounds.width > Layout.keyWindow?.bounds.height ?? UIScreen.main.bounds.height
    }
    public var phone: Bool {
        return userInterfaceIdiom == .phone
    }
    public var pad: Bool {
        return userInterfaceIdiom == .pad
    }
    public enum Size: Equatable {
        case regular(limited: Bool)
        case compact
        
        public var limited: Bool {
            switch self {
            case .regular(let limited):
                return limited
            default:
                return false
            }
        }
        public var regular: Bool {
            switch self {
            case .regular(let limited):
                return !limited
            default:
                return false
            }
        }
        public var compact: Bool {
            switch self {
            case .compact:
                return true
            default:
                return false
            }
        }
    }
}
