import UIKit
import CoreKit

@MainActor
extension Transitions.Popout {
    public final class Dismiss: NSObject, UIViewControllerAnimatedTransitioning {
        private var mask: UIView {
            let mask = UIView()
            mask.clips = true
            return mask
        }
        private var fade: UIView {
            let fade = UIView()
            fade.color = .x000000
            fade.alpha = 0.33
            return fade
        }
        private var reserve: Reserve?
        private var displayLink: CADisplayLink?
        
        private var maximum = 0.2
        private var scale: CGFloat? {
            didSet { transform() }
        }
        private var translation: CGPoint? {
            didSet { transform() }
        }
        
        public func update(translation: CGPoint) {
            self.translation = translation
        }
        
        public func update(percentage: CGFloat) {
            guard percentage < maximum else { return }
            self.scale = 1.0 - percentage
        }
        
        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.66
        }
        
        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let context = Context(from: transitionContext, direction: .backward) else {
                transitionContext.completeTransition(true)
                return
            }
            display(fps: .maximum)
            let interview = transitionContext.containerView
            maximum = context.new.superview?.convert(context.old.frame, to: nil) == nil ? 0.05 : 0.2
            let oldStandard = CGRect(x: interview.frame.origin.x, y: interview.frame.origin.y, w: interview.frame.width, h: interview.frame.height)
            let newStandard = CGRect(x: interview.frame.origin.x, y: interview.frame.height, w: interview.frame.width, h: interview.frame.height)
            let oldFrame = context.misform ? oldStandard : context.old.convert(context.old.frame).corrected(with: context.offsetY)
            let newFrame = context.misform ? newStandard : context.new.convert(context.new.frame)
            let mask = mask
            let fade = fade
            
            fade.frame = interview.frame
            mask.frame = interview.frame
            mask.corner(radius: .deviceCornerRadius)
            context.oldView.auto = false
            
            mask.add(context.oldView)
            interview.add(context.newView)
            interview.add(fade)
            interview.add(mask)
            
            context.oldView.size(of: interview)
            
            reserve = Reserve(context: context, oldFrame: oldFrame, newFrame: newFrame, interview: interview, fade: fade, mask: mask, transitionContext: transitionContext)
            guard !transitionContext.isInteractive else { return }
            set(state: .final)
        }
        
        public func set(state: State) {
            guard let reserve = reserve else { return }
            switch state {
            case .final:
                prepare(reserve: reserve)
                reserve.transitionContext?.finishInteractiveTransition()
                reserve.context.old.destroy()
                reserve.context.old.will(accept: reserve.context.new.cargo)
                reserve.context.old.transaction = nil
                reserve.context.new.transaction = nil
                if reserve.context.misform {
                    reserve.context.new.rebuild()
                }
            case .initial:
                reserve.transitionContext?.cancelInteractiveTransition()
            }
            display(fps: .maximum)
            View.animate(duration: transitionDuration(using: reserve.transitionContext),
                         spring: 1.0,
                         velocity: 0.0,
                         options: [.curveEaseInOut],
                         animations: animations(state: state),
                         completion: completion(state: state))
        }
        
        private func animations(state: State) -> () -> Void {
            guard let reserve = reserve else { return {} }
            return {
                switch state {
                case .initial:
                    reserve.mask.transform = .identity
                    reserve.mask.frame = reserve.interview.frame
                    reserve.mask.corner(radius: .deviceCornerRadius)
                    reserve.context.oldView.transform = .identity
                    reserve.context.oldView.frame = reserve.interview.frame
                    reserve.fade.alpha = 0.33
                case .final:
                    reserve.context.oldViewController.destroy()
                    reserve.context.newViewController.rebuild()
                    reserve.mask.transform = .identity
                    reserve.mask.frame = reserve.newFrame
                    reserve.mask.corner(radius: reserve.context.new.superview == nil ? .deviceCornerRadius : reserve.context.new.cornerRadius)
                    reserve.mask.relayout()
                    if !reserve.context.misform {
                        reserve.context.oldView.transform = .scale(x: reserve.context.inverted.x, y: reserve.context.inverted.y)
                    }
                    reserve.context.oldView.frame = CGRect(x: -reserve.oldFrame.origin.x * reserve.context.inverted.x,
                                                           y: -reserve.oldFrame.origin.y * reserve.context.inverted.y,
                                                           w: reserve.context.oldView.frame.width,
                                                           h: reserve.context.oldView.frame.height)
                    reserve.fade.alpha = 0.0
                }
            }
        }
        private func completion(state: State) -> (Bool) -> Void {
            guard let reserve = reserve else { return {_ in} }
            return { [weak self] _ in
                if state != .final {
                    reserve.context.old.cargo = reserve.context.new.cargo
                    reserve.context.newView.remove()
                    reserve.context.oldView.auto = true
                    reserve.interview.add(reserve.context.oldView)
                    reserve.context.oldView.transform = .identity
                    reserve.context.oldView.frame = reserve.interview.frame
                } else {
                    if !reserve.context.misform {
                        reserve.context.new.cargo = reserve.context.old.cargo
                    }
                }
                self?.scale = nil
                self?.translation = nil
                self?.reserve = nil
                reserve.fade.remove()
                reserve.mask.remove()
                reserve.transitionContext?.completeTransition(state == .final)
                display(fps: .default)
            }
        }
        private func prepare(reserve: Reserve) {
            guard !reserve.context.misform, let scroll = reserve.context.oldViewController.scroll else { return }
            scroll.offset(to: .point(x: 0, y: scroll.insets.top), animated: false)
        }
        private func transform() {
            guard let scale = scale, let translation = translation else { return }
            reserve?.mask.transform = .scale(x: scale, y: scale).concatenating(.move(x: translation.x, y: translation.y))
        }
    }
}
