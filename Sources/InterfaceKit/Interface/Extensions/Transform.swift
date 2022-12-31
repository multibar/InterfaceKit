import CoreGraphics

extension CGAffineTransform {
    public func moved(x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGAffineTransform {
        return translatedBy(x: x, y: y)
    }
    public func scaled(to value: CGFloat) -> CGAffineTransform {
        return scaledBy(x: value, y: value)
    }
    public func scaled(x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGAffineTransform {
        return scaledBy(x: x, y: y)
    }
    public static func move(x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGAffineTransform {
        return CGAffineTransform(translationX: x, y: y)
    }
    public static func scale(to value: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(scaleX: value, y: value)
    }
    public static func scale(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(scaleX: x, y: y)
    }
}
