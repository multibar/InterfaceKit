import UIKit

extension UIGestureRecognizer {
    public func drop() {
        isEnabled = false
        isEnabled = true
    }
    public static func tap(target: AnyObject, delegate: UIGestureRecognizerDelegate? = nil, action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.delegate = delegate
        return tap
    }
    public static func pan(target: AnyObject, delegate: UIGestureRecognizerDelegate? = nil, action: Selector) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        pan.delegate = delegate
        return pan
    }
}
