import UIKit
import CoreKit

@MainActor
extension Transitions.Popout {
    public final class Present: NSObject, UIViewControllerAnimatedTransitioning {
        private var mask: UIView {
            let mask = UIView()
            mask.clips = true
            return mask
        }
        private var fade: UIView {
            let fade = UIView()
            fade.color = .x000000
            fade.alpha = 0.0
            return fade
        }
        
        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.66
        }
        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let context = Context(from: transitionContext, direction: .forward) else {
                transitionContext.completeTransition(true)
                return
            }
            display(fps: .maximum)
            let interview = transitionContext.containerView
            let oldStandard = CGRect(x: interview.frame.origin.x, y: interview.frame.height, w: interview.frame.width, h: interview.frame.height)
            let newStandard = CGRect(x: 0, y: 0, w: interview.frame.width, h: interview.frame.height)
            let oldFrame = context.misform ? oldStandard : context.old.convert(context.old.frame)
            let newFrame = context.misform ? newStandard : context.new.convert(context.new.frame)
            let mask = mask
            let fade = fade
            
            fade.frame = interview.frame
            mask.frame = oldFrame
            mask.corner(radius: context.new.radius == 0.0 ? 16.0 : context.new.radius)

            if !context.misform {
                context.newView.transform = .scale(x: context.directed.x, y: context.directed.y)
                context.newView.frame = CGRect(x: -newFrame.origin.x * context.directed.x,
                                               y: (-newFrame.origin.y - context.navBarY) * context.directed.y,
                                               w: context.newView.frame.width,
                                               h: context.newView.frame.height)
                context.new.will(accept: context.old.cargo)
                context.new.cargo = context.old.cargo
            } else {
                context.newView.frame = newFrame
            }
            
            mask.add(context.newView)
            interview.add(context.oldView)
            interview.add(fade)
            interview.add(mask)
            View.animate(duration: transitionDuration(using: transitionContext),
                         spring: 1.0,
                         velocity: 0.0,
                         options: [.curveEaseInOut],
                         animations: animations(mask: mask, new: context.newView, fade: fade, interview: interview),
                         completion: completion(cancelled: transitionContext.transitionWasCancelled, context: context, mask: mask, fade: fade, interview: interview, transitionContext: transitionContext))
        }
        
        private func animations(mask: UIView, new view: UIView, fade: UIView, interview: UIView) -> () -> Void {
            return {
                mask.frame = interview.frame
                mask.corner(radius: .device)
                view.transform = .identity
                view.frame = interview.frame
                fade.alpha = 0.33
            }
        }
        private func completion(cancelled: Bool, context: Context, mask: UIView, fade: UIView, interview: UIView, transitionContext: UIViewControllerContextTransitioning) -> (Bool) -> Void {
            return { _ in
                if cancelled {
                    context.old.cargo = context.new.cargo
                    context.newView.remove()
                    fade.remove()
                    mask.remove()
                    transitionContext.completeTransition(false)
                } else {
                    interview.add(context.newView)
                    context.newView.frame = interview.frame
                    fade.remove()
                    mask.remove()
                    transitionContext.completeTransition(true)
                }
                display(fps: .default)
            }
        }
    }
}
