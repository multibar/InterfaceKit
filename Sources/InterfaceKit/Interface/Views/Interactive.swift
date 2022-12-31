import UIKit

public protocol Touchable: UIView {
    var highlighted: Bool { get }
    var highlightable: Bool { get }
    var touches: View.Interactive.Touches { get set }
}

extension View {
    open class Interactive: View, Touchable {
        open var stacked = false
        open var highlighted = false
        open var highlightable = true
        open var touches: Touches = .finished(success: false) {
            didSet {
                switch touches {
                case .begun, .enter, .moved:
                    guard highlightable else { return }
                    highlighted = true
                case .exit, .ended, .cancelled, .finished:
                    guard highlightable else { return }
                    highlighted = false
                }
            }
        }
        
        open override func setup() {
            super.setup()
            interactive = true
        }
        
        open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            guard !stacked else { return }
            self.touches = .begun
        }
        open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            guard !stacked else { return }
            guard let location = touches.first?.location(in: self) else { self.touches = .ended; return }
            self.touches = bounds.contains(location) ? .finished(success: true) : .ended
        }
        open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesCancelled(touches, with: event)
            guard !stacked else { return }
            self.touches = .cancelled
        }
        open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)
            guard !stacked else { return }
            guard let location = touches.first?.location(in: self) else { return }
            self.touches = .moved(to: location)
        }
    }
}

extension View.Interactive {
    public enum Touches {
        case begun, enter, exit, ended, cancelled, finished(success: Bool), moved(to: CGPoint)
    }
}
