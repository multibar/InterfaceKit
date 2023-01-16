import UIKit

extension CGSize {
    public var format: View.Format {
        if width > height {
            return .landscape
        } else if width < height {
            return .portrait
        } else if width == height {
            return .square
        } else {
            return .auto
        }
    }
    public init(w: CGFloat, h: CGFloat) {
        self.init(width: w, height: h)
    }
    public var ratio: CGFloat {
        return width/height
    }
}
extension CGSize {
    public static func size(_ size: CGFloat) -> CGSize {
        return CGSize(w: size, h: size)
    }
    public static func size(w: CGFloat, h: CGFloat) -> CGSize {
        return CGSize(w: w, h: h)
    }
}
