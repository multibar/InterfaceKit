import UIKit
import CoreKit

@MainActor
extension Transitions.Linear {
    public final class Push: NSObject, UIViewControllerAnimatedTransitioning {
        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }
        
        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let sender = transitionContext.viewController(forKey: .from),
            let recipient = transitionContext.viewController(forKey: .to) else { return }
            display(fps: .maximum)
            let container = transitionContext.containerView
            let dim = UIView(frame: sender.view.bounds)
            dim.color = .x000000
            dim.alpha = 0
            recipient.view.frame = CGRect(origin: .point(x: container.bounds.width, y: 0), size: container.bounds.size)
            container.add(dim)
            container.add(recipient.view)
            View.animate(duration: transitionDuration(using: transitionContext),
                         spring: 1.0,
                         velocity: 0.5,
                         interactive: transitionContext.isInteractive,
                         options: [.curveLinear],
                         animations: animations(sender: sender, recipient: recipient, dim: dim, container: container),
                         completion: { _ in
                dim.remove()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                display(fps: .default)
            })
        }
        
        private func animations(sender: UIViewController, recipient: UIViewController, dim: UIView, container: UIView) -> () -> Void {
            return {
                sender.view.frame = CGRect(origin: .point(x: -sender.view.frame.width/4, y: 0), size: sender.view.bounds.size)
                recipient.view.frame = CGRect(origin: .zero, size: container.bounds.size)
                dim.alpha = 0.25
            }
        }
    }
}
