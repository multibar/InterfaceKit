import UIKit
import CoreKit

public protocol NavigationBarCellDelegate: AnyObject {
    func back()
}
extension NavigationController.Bar {
    public class Cell: View.Interactive {
        private let item: Item
        private let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 0
            return stack
        }()
        public override var highlighted: Bool {
            didSet {
                guard highlighted != oldValue else { return }
                set(highlighted: highlighted)
            }
        }
        public override var touches: View.Interactive.Touches {
            didSet {
                switch touches {
                case .success:
                    switch item {
                    case .back(_, let action):
                        guard let action else {
                            delegate?.back()
                            break
                        }
                        action()
                    default:
                        item.action?()
                    }
                default:
                    break
                }
            }
        }
        private weak var delegate: NavigationBarCellDelegate?
        
        public required init(item: Item, delegate: NavigationBarCellDelegate) {
            self.item = item
            self.delegate = delegate
            var highlightable = false
            switch item {
            case .back(let direction, _):
                let imageView = UIImageView(image: direction.icon)
                imageView.contentMode = .scaleAspectFit
                imageView.width(32)
                stack.append(imageView)
            case .icon(let icon, let attributes, _, let width, let _highlightable, _):
                let icon = icon?.withTintColor(attributes.color)
                let imageView = UIImageView(image: icon)
                imageView.width(width ?? 24)
                imageView.contentMode = .scaleAspectFit
                stack.append(imageView)
                highlightable = _highlightable
            case .view(let view, let attributes, _, let width, let _highlightable, _):
                if let width = width { view.width(width) }
                view.tint = attributes.color
                stack.append(view)
                highlightable = _highlightable
            }
            super.init(frame: .zero)
            self.highlightable = highlightable
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        public override func setup() {
            super.setup()
            stack.auto = false
            add(stack)
            stack.box(in: self)
        }
        
        open func set(highlighted: Bool) {
            View.animate(duration: 0.33,
                         spring: 1.0,
                         velocity: 0.5,
                         options: [.curveEaseInOut, .allowUserInteraction]) {
                self.stack.transform = highlighted ? .scale(to: 0.8) : .identity
            }
        }
    }
}
extension NavigationController.Bar.Item.Back.Direction {
    fileprivate var icon: UIImage? {
        switch self {
        case .left: return Self.chevron_left
        case .down: return Self.chevron_down
        }
    }
    fileprivate static let chevron_left = UIImage.pdf(from: Bundle.module.url(forResource: "chevron_left", withExtension: "pdf")) ?? UIImage()
    fileprivate static let chevron_down = UIImage.pdf(from: Bundle.module.url(forResource: "chevron_down", withExtension: "pdf")) ?? UIImage()
}
