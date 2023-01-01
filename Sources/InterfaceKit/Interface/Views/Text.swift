import UIKit
import CoreKit

open class Text: UITextView {
    public weak var router: Router?
    public required init() {
        super.init(frame: .zero, textContainer: nil)
        contentInsetAdjustmentBehavior = .never
        backgroundColor = nil
        #if os(iOS)
        dataDetectorTypes = .link
        isEditable = false
        #endif
        textContainerInset = .zero
        textContainer.lineFragmentPadding = .zero
        insets = .zero
        isSelectable = true
        isScrollEnabled = false
        clipsToBounds = true
        delegate = self
        setup()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func setup() {}

    open func set(text: String, attributes: Attributes) {
        attributedText = NSMutableAttributedString(text: text, attributes: attributes)
        linkTextAttributes = [.foregroundColor: UIColor.x58ABF5]
    }
    open func set(text: NSAttributedString, attributes: Attributes) {
        attributedText = NSMutableAttributedString(text: text, attributes: attributes)
        linkTextAttributes = [.foregroundColor: UIColor.x58ABF5]
    }
    open func process(route: Route) {
        router?.process(route: route)
    }
}
extension Text {
    public func clear() {
        attributedText = nil
    }
}
extension Text: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard UIApplication.shared.canOpenURL(URL) else { return false }
        guard URL.scheme?.contains("mailto") == false, URL.scheme?.contains("tel") == false else { return true }
        process(route: Route(with: URL.string))
        return false
    }
}
