import UIKit

extension CGRect {
    public var empty: Bool {
        return isEmpty
    }
    public static var shortest: CGRect {
        return CGRect(x: 0, y: 0, w: 0, h: CGFloat.leastNormalMagnitude)
    }
    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}

