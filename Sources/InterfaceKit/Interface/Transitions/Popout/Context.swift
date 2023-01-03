import UIKit
import CoreKit

extension Transitions.Popout {
    public struct Context {
        public let old    : Container
        public let new    : Container
        public let oldView: UIView
        public let newView: UIView
        public let oldViewController: ViewController
        public let newViewController: ViewController
        public let misform: Bool
        public let offsetY: CGFloat
        public let navBarY: CGFloat
        
        public var directed: Scale {
            guard !old.frame.empty && !new.frame.empty else { return Scale(x: 1.0, y: 1.0) }
            return Scale(x: old.frame.width / new.frame.width, y: old.frame.height / new.frame.height)
        }
        
        public var inverted: Scale {
            guard !old.frame.empty && !new.frame.empty else { return Scale(x: 1.0, y: 1.0) }
            return Scale(x: new.frame.width / old.frame.width, y: new.frame.height / old.frame.height)
        }
        
        public struct Scale {
            public let x: CGFloat
            public let y: CGFloat
        }
        
        public init?(from context: UIViewControllerContextTransitioning, direction: Direction) {
            guard let oldViewController = context.viewController(forKey: .from) as? ViewController,
                  let newViewController = context.viewController(forKey: .to) as? ViewController
            else { return nil }
            let old = direction == .forward ? oldViewController.containerB : oldViewController.containerA
            let new = direction == .forward ? newViewController.containerA : newViewController.containerB
            self.oldViewController = oldViewController
            self.newViewController = newViewController
            if let old = old, let new = new, old.format == new.format, !oldViewController.traits.segmented {
                switch direction {
                case .forward:
                    let transaction = UUID()
                    old.transaction = transaction
                    new.transaction = transaction
                    self.old = old
                    self.new = new
                    self.misform = false
                case .backward:
                    if let oldTransaction = old.transaction,
                       let newTransaction = new.transaction,
                       oldTransaction == newTransaction {
                        self.misform = false
                    } else {
                        self.misform = true
                    }
                    self.old = old
                    self.new = new
                }
            } else {
                self.old = old ?? _Container()
                self.new = new ?? _Container()
                self.misform = true
            }
            self.oldView = oldViewController.view
            self.offsetY = (oldViewController.scroll?.offset.y ?? 0) + (oldViewController.scroll?.insets.top ?? 0)
            self.newView = newViewController.view
            self.navBarY = newViewController.navBarOffsets ? newViewController.navBar == nil ? 0 : newViewController.navBarStyle.size.estimated : 0
        }
    }
}
extension Transitions.Popout.Context {
    public enum Direction {
        case forward
        case backward
    }
}

extension Transitions.Popout {
    public struct Reserve {
        public let context: Context
        public let oldFrame: CGRect
        public let newFrame: CGRect
        public let interview: UIView
        public let fade: UIView
        public let mask: UIView
        public weak var transitionContext: UIViewControllerContextTransitioning?
    }
}

extension Transitions.Popout {
    public enum State {
        case initial
        case final
    }
}

fileprivate class _Container: UIView, Container {
    let identifier = UUID()
    var transaction: UUID?
    var cargo = UIView()
    var format: View.Format = .auto
    var adaptive: Bool {
        return false
    }
    func loaded() {}
    func rebuild() {}
    func destroy() {}
    func will(accept cargo: UIView) {}
}

extension CGRect {
    internal func corrected(with offsetY: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y + offsetY, w: width, h: height)
    }
}
