import UIKit
import CoreKit

extension NavigationController {
    public class Bar: View {
        private var background: Blur = {
            let background = Blur()
            background.color = .clear
            background.blurRadius = 8
            return background
        }()
        private var style: Style = .none {
            didSet {
                separator.alpha = style.separator.fade ? 0.0 : 1.0
                separator.color = style.separator.color
                background.colorTint = style.background.color
                background.colorTintAlpha = style.background.alpha
            }
        }
        private var inset = Constraint()
        private var stack: Stack = Stack() {
            didSet {
                oldValue.remove()
                stack.auto = false
                add(stack)
                inset = stack.top(to: top, constant: style.size.inset, active: true)
                stack.bottom(to: bottom)
                stack.left(to: safeLeft)
                stack.right(to: safeRight)
                bringSubviewToFront(separator)
            }
        }
        private let separator = View()
        private weak var viewController: ViewController?
        public required init(viewController: ViewController) {
            super.init(frame: .zero)
            set(viewController: viewController)
        }
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func layout() {
            guard System.App.state != .background else { return }
            inset.constant = style.size.inset
            relayout()
        }
        
        public override func setup() {
            super.setup()
            setupUI()
        }
                
        private func setupUI() {
            separator.auto = false
            background.auto = false
            add(background)
            add(separator)
            background.box(in: self)
            separator.left(to: left)
            separator.right(to: right)
            separator.bottom(to: bottom)
            separator.height(0.33)
        }
        
        public func set(viewController: ViewController) {
            self.viewController = viewController
            Task { await MainActor.run {
                let style = viewController.navBarStyle
                let items = viewController.navigation?.rootViewController.identifier == viewController.identifier ? viewController.navBarItems : viewController.navBarItems.backed(with: style.attributes)
                let stack = stack(from: items, style: style)
                let hidden = viewController.navBarHidden
                set(hidden: hidden)
                viewController.inset(top: style.size.height)
                self.style = style
                self.stack = stack
                self.set(hidden: hidden)
            }}
        }
        public func set(hidden: Bool, animated: Bool = true) {
            let bar = self
            View.animate(duration: animated ? 0.5 : 0.0,
                         spring: 1.0,
                         velocity: 1.0,
                         interactive: !animated,
                         options: [.allowUserInteraction, .curveLinear]) {
                bar.alpha = hidden ? 0.0 : 1.0
                bar.transform = hidden ? .move(y: -bar.frame.height) : .identity
            }
        }
        
        private func stack(from items: [Item], style: Style) -> Stack {
            let stack = Stack()
            stack.alignment = .fill
            stack.distribution = style.fill ? .fill : .fillProportionally
            stack.axis = .horizontal
            stack.layoutMargins = style.insets
            stack.isLayoutMarginsRelativeArrangement = true
            stack.spacing = style.spacing.inter / 2
            stack.height(style.size.height)
            let left = Stack()
            left.axis = .horizontal
            left.alignment = .fill
            left.distribution = .fill
            left.spacing = style.spacing.left
            let middle = Stack()
            middle.axis = .horizontal
            middle.alignment = .fill
            middle.distribution = .fill
            middle.spacing = style.spacing.middle
            let right = Stack()
            right.axis = .horizontal
            right.alignment = .fill
            right.distribution = .fill
            right.spacing = style.spacing.right
            items.forEach {
                let cell = Cell(item: $0, delegate: self)
                switch $0.position {
                case .left:
                    left.append(cell)
                case .middle:
                    middle.append(cell)
                case .right:
                    right.append(cell)
                }
            }
            stack.append(left)
            stack.append(View())
            stack.append(middle)
            stack.append(View())
            stack.append(right)
            middle.centerX(to: stack.centerX, priority: .defaultLow)
            return stack
        }
    }
}
extension NavigationController.Bar {
    public func handle(content offset: CGPoint) {
        guard style.separator.fade else { return }
        View.animate(duration: 0.125) {
            self.separator.alpha = offset.alpha
        }
    }
}
extension NavigationController.Bar {
    public struct Style {
        public let background : Background
        public let attributes : Attributes
        public let separator  : Separator
        public let size       : Size
        public let insets     : UIEdgeInsets
        public let spacing    : Spacing
        public let fill       : Bool
        
        public init(background: Background = .none,
                    attributes: Attributes = .default,
                    separator : Separator = .none,
                    size      : Size = .regular,
                    insets    : UIEdgeInsets = .insets(left: 16, right: 16),
                    spacing   : Spacing = Spacing(),
                    fill      : Bool = true) {
            self.background = background
            self.attributes = attributes
            self.separator = separator
            self.size = size
            self.insets = insets
            self.spacing = spacing
            self.fill = fill
        }
        
        public enum Background: Equatable {
            case blur(UIColor)
            case color(UIColor)
            case none
            
            public var color: UIColor? {
                switch self {
                case .blur(let color):
                    return color.invisible ? nil : color.withAlphaComponent(1.0)
                case .color(let color):
                    return color.invisible ? nil : color.withAlphaComponent(1.0)
                case .none:
                    return nil
                }
            }
            public var alpha: CGFloat {
                switch self {
                case .blur:
                    return 0.95
                case .color:
                    return 1.0
                case .none:
                    return 0.0
                }
            }
        }
        public enum Separator: Equatable {
            case color(UIColor, fade: Bool = true)
            case none
            
            public var color: UIColor? {
                switch self {
                case .color(let color, _):
                    return color.invisible ? nil : color
                default:
                    return nil
                }
            }
            public var fade: Bool {
                switch self {
                case .color(_, let fade):
                    return fade
                default:
                    return false
                }
            }
        }
        public enum Size {
            case large
            case regular
            case clipped
            
            public var inset: CGFloat {
                switch self {
                case .clipped:
                    return 0
                case .large, .regular:
                    return Layout.SafeArea.top
                }
            }
            public var height: CGFloat {
                switch self {
                case .large:
                    return 88
                case .regular, .clipped:
                    return 44
                }
            }
            public static func estimated(for controller: ViewController) -> CGFloat {
                guard !controller.navBarItems.empty && !controller.navBarHidden else { return 0.0 }
                let size = controller.navBarStyle.size
                switch size {
                case .clipped:
                    return size.height
                case .large, .regular:
                    return size.height + Layout.SafeArea.top
                }
            }
        }
        public struct Spacing {
            public let left: CGFloat
            public let middle: CGFloat
            public let right: CGFloat
            public let inter: CGFloat
            
            public init(left: CGFloat = 8, middle: CGFloat = 8, right: CGFloat = 8, inter: CGFloat = 16) {
                self.left = left
                self.middle = middle
                self.right = right
                self.inter = inter
            }
        }
        public enum Shadow {
            case none
            case `default`(color: UIColor = .x000000, opacity: Float = 0.1, offset: CGSize = .zero, radius: CGFloat = 3.0)
        }
    }
}
extension NavigationController.Bar: NavigationBarCellDelegate {
    public func back() {
        guard let viewController, let navigation = viewController.navigation else { return }
        if navigation.rootViewController == viewController && navigation.presenting != nil {
            navigation.dismiss(animated: true)
        } else {
            navigation.back()
        }
    }
}
extension Array where Element == NavigationController.Bar.Item {
    public func backed(with attributes: Attributes) -> [NavigationController.Bar.Item] {
        var backed = false
        forEach({
            switch $0 {
            case .back: backed = true
            default   : break
            }
        })
        guard !backed else { return self }
        var items = self
        items.insert(.back(direction: .left), at: 0)
        return items
    }
}
extension NavigationController.Bar.Style {
    public static var none: NavigationController.Bar.Style {
        return NavigationController.Bar.Style(background: .none,
                                              attributes: .default,
                                              size: .regular)
    }
}
extension UIViewController {
    internal func inset(top: CGFloat) {
        additionalSafeAreaInsets = .insets(top: top)
    }
}
extension CGPoint {
    public var alpha: CGFloat {
        var alpha: CGFloat = 0
        if y > 0 {
            alpha += y/88
            if alpha > 1 { alpha = 1 }
        } else {
            alpha = 0
        }
        return alpha
    }
}
