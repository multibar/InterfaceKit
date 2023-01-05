import UIKit

extension UIEdgeInsets {
    public static func insets(all inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    public static func insets(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
