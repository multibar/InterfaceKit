import UIKit

@MainActor
open class View: UIView {
    public let id = UUID()
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        auto = false
        setup()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func setup() {}
}
extension View {
    public enum Format: Codable, Hashable {
        case landscape
        case portrait
        case square
        case auto
    }
}
extension View {
    public static func animate(duration: CGFloat,
                               delay: CGFloat = 0.0,
                               options: UIView.AnimationOptions = [.allowUserInteraction],
                               animations: @escaping () -> Void,
                               completion: ((Bool) -> Void)? = nil) {
        return UIView.animate(withDuration: duration,
                              delay: delay,
                              options: options,
                              animations: animations,
                              completion: completion)
    }
    public static func animate(duration: CGFloat,
                               delay: CGFloat = 0.0,
                               spring: CGFloat,
                               velocity: CGFloat,
                               interactive: Bool = false,
                               options: UIView.AnimationOptions = [.allowUserInteraction],
                               animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        if interactive {
            return UIView.animate(withDuration: duration,
                                  delay: delay,
                                  options: options,
                                  animations: animations,
                                  completion: completion)
        } else {
            return UIView.animate(withDuration: duration,
                                  delay: delay,
                                  usingSpringWithDamping: spring,
                                  initialSpringVelocity: velocity,
                                  options: options,
                                  animations: animations,
                                  completion: completion)
        }
    }
}

extension UIView {
    public var interactive: Bool {
        get { isUserInteractionEnabled }
        set { isUserInteractionEnabled = newValue }
    }
    public func relayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    public func add(_ subview: UIView) {
        addSubview(subview)
    }
    public func insert(_ subview: UIView, at index: Int) {
        insertSubview(subview, at: index)
    }
    public func insert(_ subview: UIView, above view: UIView) {
        insertSubview(subview, aboveSubview: view)
    }
    public func insert(_ subview: UIView, below view: UIView) {
        insertSubview(subview, belowSubview: view)
    }
    public func remove() {
        removeFromSuperview()
    }
    public func add(gesture recognizer: UIGestureRecognizer) {
        addGestureRecognizer(recognizer)
    }
}
extension UIView {
    public var color: UIColor? {
        get { backgroundColor }
        set { backgroundColor = newValue }
    }
    public var tint: UIColor? {
        get { tintColor }
        set { tintColor = newValue }
    }
    public var hidden: Bool {
        get { isHidden }
        set { isHidden = newValue }
    }
    public var clips: Bool {
        get { clipsToBounds }
        set { clipsToBounds = newValue }
    }
    public var corners: CACornerMask {
        get { layer.maskedCorners }
        set { layer.maskedCorners = newValue }
    }
    public func corner(radius: CGFloat, curve: CALayer.Curve = .continuous) {
        clips = true
        layer.corner(radius: radius, curve: curve)
    }
    public func border(width: CGFloat) {
        layer.borderWidth = width
    }
    public func border(color: UIColor?) {
        layer.borderColor = color?.cgColor
    }
    public func convert(_ rect: CGRect) -> CGRect {
        var view = self
        var frame = rect
        while let superview = view.superview {
            view = superview
            frame = superview.convert(frame, to: superview.superview)
        }
        return frame
    }
}
extension UIView {
    public func shadow(color: UIColor = .x000000, opacity: Float = 0.1, offset: CGSize = .size(w: 0.0, h: -2.0), radius: CGFloat = 3.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    public func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
    }
}
