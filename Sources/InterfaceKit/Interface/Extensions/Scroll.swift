import UIKit

extension UIScrollView {
    /// Content Size.
    public var size: CGSize {
        get { contentSize }
        set { contentSize = newValue }
    }
    
    /// Content Offset.
    public var offset: CGPoint {
        get { contentOffset }
        set { contentOffset = newValue }
    }
    
    /// Content Insets.
    public var insets: UIEdgeInsets {
        get { contentInset }
        set { contentInset = newValue }
    }
    
    /// Is Scroll Enabled
    public var enabled: Bool {
        get { isScrollEnabled }
        set { isScrollEnabled = newValue }
    }
    
    /// Returns true if scroll at the bottom or if content size is less than scroll height.
    public var descended: Bool {
        guard (size.height + insets.top + insets.bottom) >= frame.height else { return true }
        return offset.y + frame.height - insets.bottom >= size.height
    }
    
    /// Scrolls to desired point.
    public func offset(to point: CGPoint, animated: Bool = true) {
        setContentOffset(point, animated: animated)
    }
}
