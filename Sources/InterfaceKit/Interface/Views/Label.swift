import UIKit

open class Label: UILabel {
    public func clear() {
        attributedText = nil
    }
    public required init(lines: Int = 1, frame: CGRect = .zero) {
        super.init(frame: frame)
        numberOfLines = lines
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UILabel {
    open override var tintColor: UIColor! {
        didSet {
            guard let attributedString = attributedText, let color = tintColor else { return }
            let mutable = NSMutableAttributedString(attributedString: attributedString)
            mutable.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: mutable.length))
            attributedText = mutable
        }
    }
    public convenience init(text: String, attributes: Attributes? = nil, frame: CGRect = .zero) {
        self.init(frame: frame)
        guard let attributes = attributes else {
            attributedText = NSAttributedString(string: text)
            return
        }
        set(text: text, attributes: attributes)
    }
    
    public func set(text: String?, attributes: Attributes, animated: Bool = false) {
        guard let text = text else {
            attributedText = nil
            return
        }
        if animated {
            let fade = CATransition()
            fade.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            fade.type = .fade
            fade.duration = 0.15
            layer.add(fade, forKey: CATransitionType.fade.rawValue)
        }
        font = attributes.typography.font
        textColor = attributes.color
        attributedText = NSMutableAttributedString(text: text, attributes: attributes)
    }
    public func paint(substring: String, in color: UIColor) {
        guard let attributedString = attributedText else { return }
        let mutable = NSMutableAttributedString(attributedString: attributedString)
        mutable.addAttribute(.foregroundColor, value: color, range: mutable.mutableString.range(of: substring))
        attributedText = mutable
    }
}
extension NSAttributedString {
    fileprivate static func attributed(text: String, attributes: Attributes) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = attributes.typography.alignment
        paragraph.lineHeightMultiple = attributes.typography.spacing.line
        paragraph.paragraphSpacing = attributes.typography.spacing.line
        paragraph.lineBreakMode = attributes.typography.lineBreakMode ?? .byTruncatingTail
        paragraph.hyphenationFactor = attributes.typography.hyphens ? 1.0 : 0.0
        attributedString.addAttribute(.kern, value: attributes.typography.spacing.char, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: attributes.typography.font, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.strikethroughStyle, value: attributes.typography.strikethrough, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.strikethroughColor, value: attributes.color, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: attributes.color, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
extension NSMutableAttributedString {
    public convenience init(text: String, attributes: Attributes) {
        self.init(attributedString: .attributed(text: text, attributes: attributes))
    }
    public convenience init(text: NSAttributedString, attributes: Attributes) {
        self.init(attributedString: .attributed(text: text.string, attributes: attributes))
    }
}
