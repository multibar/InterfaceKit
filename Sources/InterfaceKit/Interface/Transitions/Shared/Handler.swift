import UIKit

public protocol TransitionHandlerDelegate: AnyObject {
    func will(show controller: NavigationController.Controller)
    func did(show controller: NavigationController.Controller)
}

extension Transitions {
    public class Handler: NSObject {
        private let push    = Linear.Push()
        private let pop     = Linear.Pop()
        private let present = Popout.Present()
        private let dismiss = Popout.Dismiss()
        
        public let linear = Linear.Interactor()
        public lazy var popout = Popout.Interactor(transition: dismiss)
        public var interaction: Interaction = .none
        
        public weak var delegate: TransitionHandlerDelegate?
    }
}

extension Transitions.Handler: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push: return fromVC.presentable(to: toVC) ? present : push
        case .pop : return fromVC.dismissable(to: toVC) ? dismiss : pop
        default   : return nil
        }
    }
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch interaction {
        case .pop    : return linear
        case .dismiss: return popout
        default      : return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let controller = viewController as? ViewController else {
            delegate?.will(show: .legacy(viewController))
            return
        }
        delegate?.will(show: .modern(controller))
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let controller = viewController as? ViewController else {
            delegate?.did(show: .legacy(viewController))
            return
        }
        delegate?.did(show: .modern(controller))
    }
}

extension Transitions.Handler {
    public enum Interaction {
        case pop
        case dismiss
        case none
    }
}
