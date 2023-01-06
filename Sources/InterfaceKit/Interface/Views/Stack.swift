import UIKit

open class Stack: UIStackView {
    private let haptic = Haptic.Selector()
    open var stacked = false
    open var highlighted: View.Interactive? {
        didSet {
            haptic.prepare()
            guard oldValue != highlighted else { return }
            oldValue?.touches = .ended
            highlighted?.touches = .begun
            guard haptics && highlighted != nil else { return }
            haptic.generate()
        }
    }
    open var items: [View.Interactive] {
        var items: [View.Interactive] = []
        arranged.forEach { subview in
            switch subview {
            case let stack as Stack:
                items.append(contentsOf: stack.items)
            case let interactive as View.Interactive:
                items.append(interactive)
            default:
                break
            }
        }
        return items
    }
    public var haptics = false
    
    public required override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        insetsLayoutMarginsFromSafeArea = false
        setup()
    }
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {}
    open override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        switch view {
        case let interactive as View.Interactive:
            interactive.stacked = true
        case let stack as Stack:
            stack.stacked = true
        default:
            break
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !stacked else { return }
        guard let location = touches.first?.location(in: self) else { return }
        highlighted = items.first{$0.convert($0.bounds, to: self).contains(location)}
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard !stacked else { return }
        if let location = touches.first?.location(in: self) {
            items.first{$0.convert($0.bounds, to: self).contains(location)}?.touches = .success
        }
        items.forEach {$0.touches = .ended}
        highlighted = nil
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard !stacked else { return }
        items.forEach {$0.touches = .cancelled}
        highlighted = nil
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard !stacked else { return }
        guard let location = touches.first?.location(in: self) else { return }
        highlighted = items.first{$0.convert($0.bounds, to: self).contains(location)}
    }
}

extension UIStackView {
    public var arranged: [UIView] {
        return arrangedSubviews
    }
    public func append(_ subview: UIView) {
        addArrangedSubview(subview)
        switch subview {
        case let interactive as View.Interactive:
            interactive.stacked = true
        case let stack as Stack:
            stack.stacked = true
        default:
            break
        }
    }
    public func append(_ subviews: [UIView]) {
        subviews.forEach { subview in
            append(subview)
            switch subview {
            case let interactive as View.Interactive:
                interactive.stacked = true
            case let stack as Stack:
                stack.stacked = true
            default:
                break
            }
        }
    }
    public func pop(_ subview: UIView? = nil) {
        guard let subview = arrangedSubviews.first(where: {$0 == subview}) else {
            arrangedSubviews.last?.removeFromSuperview()
            return
        }
        subview.removeFromSuperview()
    }
    public func clear() {
        arranged.forEach({$0.remove()})
    }
}
