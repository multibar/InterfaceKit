import UIKit

open class Stack: UIStackView {
    open var highlighted: View.Interactive? {
        didSet {
            guard oldValue != highlighted else { return }
            oldValue?.touches = .ended
            highlighted?.touches = .begun
            guard haptics && highlighted != nil else { return }
            Haptic.selection.generate()
        }
    }
    open var items: [View.Interactive]? {
        return stacked.filter({$0 is View.Interactive}) as? [View.Interactive]
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
        guard let interactive = view as? View.Interactive else { return }
        interactive.stacked = true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        highlighted = items?.first{$0.frame.contains(location)}
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let item = touches.first?.view as? View.Interactive {
            item.touches = .finished(success: true)
        } else if let location = touches.first?.location(in: self) {
            self.items?.first{$0.frame.contains(location)}?.touches = .finished(success: true)
        }
        items?.forEach {$0.touches = .ended}
        highlighted = nil
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        items?.forEach {$0.touches = .cancelled}
        highlighted = nil
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        highlighted = items?.first{$0.frame.contains(location)}
    }
}

extension UIStackView {
    public var stacked: [UIView] {
        return arrangedSubviews
    }
    public func append(_ subview: UIView) {
        addArrangedSubview(subview)
    }
    public func append(_ subviews: [UIView]) {
        subviews.forEach({append($0)})
    }
    public func clear() {
        stacked.forEach({$0.remove()})
    }
}
