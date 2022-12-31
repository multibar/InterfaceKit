import UIKit

extension Transitions.Linear {
    public class Interactor: UIPercentDrivenInteractiveTransition {
        private weak var context: UIViewControllerContextTransitioning?
        
        public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
            self.context = transitionContext
            super.startInteractiveTransition(transitionContext)
        }
        public override func update(_ percentComplete: CGFloat) {
            super.update(percentComplete)
        }
        public override func cancel() {
            context?.cancelInteractiveTransition()
            super.cancel()
        }
        public override func finish() {
            context?.finishInteractiveTransition()
            super.finish()
        }
    }
}

extension Transitions.Popout {
    public class Interactor: UIPercentDrivenInteractiveTransition {
        private weak var context: UIViewControllerContextTransitioning?
        private let transition: Dismiss

        public init(transition: Dismiss) {
            self.transition = transition
            super.init()
        }
        
        public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
            self.context = transitionContext
            super.startInteractiveTransition(transitionContext)
        }
        public override func update(_ percentComplete: CGFloat) {
            transition.update(percentage: percentComplete)
            super.update(percentComplete)
        }
        public func update(translation: CGPoint) {
            transition.update(translation: translation)
        }
        public override func cancel() {
            transition.set(state: .initial)
            super.cancel()
        }
        public override func finish() {
            transition.set(state: .final)
            super.finish()
        }
    }
}
