import UIKit
import CoreKit

open class NavigationController: UINavigationController, ViewController {
    public let identifier = UUID()
    
    open var route: Route {
        return viewController?.route ?? .none
    }
    open var forcePresent: Bool {
        return viewController?.forcePresent ?? false
    }
    open var containerA: Container? {
        return viewController?.containerA
    }
    open var containerB: Container? {
        return viewController?.containerB
    }
    open var multibar: Bool {
        return viewController?.multibar ?? true
    }
    open var content: UIView {
        return viewController?.content ?? view
    }
    open var scroll: UIScrollView? {
        return viewController?.scroll
    }

    #if os(iOS)
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    open override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return topViewController?.prefersHomeIndicatorAutoHidden ?? super.prefersHomeIndicatorAutoHidden
    }
    #endif
    
    public let rootViewController: ViewController
    open var viewController: ViewController? {
        return topViewController as? ViewController
    }
    open var navBar: Bar? {
        get { viewController?.navBar }
        set { viewController?.navBar = newValue }
    }
    open var navBarStyle: NavigationController.Bar.Style {
        return viewController?.navBarStyle ?? .none
    }
    open var navBarItems: [NavigationController.Bar.Item] {
        return viewController?.navBarItems ?? []
    }
    
    private let handler = Transitions.Handler()
    private let pan = UIPanGestureRecognizer()
    
    public required init(viewController: ViewController) {
        self.rootViewController = viewController
        super.init(rootViewController: viewController)
        setup(with: viewController)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    open func setup(with viewController: ViewController) {
        setupUI()
        bar(for: viewController)
    }
    
    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        navBar?.layout()
    }
    
    open func app(state: System.App.State) {
        (viewControllers as? [ViewController])?.forEach({$0.app(state: state)})
    }
    open func user(state: System.User.State) {
        (viewControllers as? [ViewController])?.forEach({$0.user(state: state)})
    }
    open func update(traits: UITraitCollection) {
        navBar?.layout()
        (viewControllers as? [ViewController])?.forEach({$0.update(traits: traits)})
    }
    open func process(route: Route) {
        viewController?.process(route: route)
    }
    open func prepare() {}
    open func rebuild() {}
    open func destroy() {}
    
    private func setupUI() {
        navigationBar.hidden = true
        #if !os(tvOS)
        setupTransitions()
        setupInteractiveGestures()
        #endif
    }
    private func setupTransitions() {
        handler.delegate = self
        delegate = handler
    }
    private func setupInteractiveGestures() {
        pan.addTarget(self, action: #selector(panned(_:)))
        pan.delegate = self
        view.add(gesture: pan)
    }
    
    private func bar(for viewController: ViewController) {
        guard viewController.navBar == nil, !viewController.navBarItems.empty else {
            viewController.navBar?.layout()
            return
        }
        let bar = Bar(viewController: viewController)
        bar.auto = false
        viewController.view.add(bar)
        viewController.navBar = bar
        bar.top(to: viewController.view.top)
        bar.left(to: viewController.view.left)
        bar.right(to: viewController.view.right)
    }
    
    @objc
    private func panned(_ recognizer: UIPanGestureRecognizer) {
        guard transitionCoordinator?.isCancelled != true else { recognizer.isEnabled = false; recognizer.isEnabled = true; return }
        switch handler.interaction {
        case .none:
            handler.interaction = interaction
            popViewController(animated: true)
        case .back:
            let translation = recognizer.translation(in: view)
            let percentage = max(0.0, min(1.0, translation.x / view.frame.width))
            switch recognizer.state {
            case .changed:
                handler.linear.update(percentage)
            case .ended, .cancelled:
                handler.interaction = .none
                let velocity = recognizer.velocity(in: view)
                let relative = velocity.x/2000
                if percentage > 0.2 || velocity.x > 1000 {
                    handler.linear.completionSpeed = (1.0 - percentage) + abs(relative)
                    handler.linear.finish()
                } else {
                    handler.linear.completionSpeed = percentage+0.1
                    handler.linear.cancel()
                }
            default:
                break
            }
        case .dismiss:
            let translation = recognizer.translation(in: view)
            let percentage = (abs(translation.y) + abs(translation.x)) / (view.bounds.height + view.bounds.width)
            switch recognizer.state {
            case .changed:
                handler.popout.update(percentage)
                handler.popout.update(translation: .point(x: translation.x * 0.5, y: translation.y * 0.5))
            case .ended, .cancelled:
                handler.interaction = .none
                let velocity = recognizer.velocity(in: view)
                let relative = velocity.x/2000
                if percentage > 0.2 || velocity.x > 1000 || velocity.y > 1000 {
                    handler.popout.completionSpeed = (1.0 - percentage) + abs(relative)
                    handler.popout.finish()
                } else {
                    handler.popout.completionSpeed = percentage+0.1
                    handler.popout.cancel()
                }
            default:
                break
            }
        }
    }
}
extension NavigationController {
    public var interaction: Transitions.Handler.Interaction {
        guard let viewController = viewController,
              let previousViewController = viewControllers.previous(before: viewController),
              viewController.dismissable(to: previousViewController)
        else { return .back }
        return .dismiss
    }
    public func updateBar() {
        guard let viewController else { return }
        navBar?.set(viewController: viewController)
    }
}
extension NavigationController {
    public func push(_ viewController: ViewController, animated: Bool = true) {
        pushViewController(viewController, animated: animated)
    }
    public func back(to distance: Distance = .previous, animated: Bool = true) {
        switch distance {
        case .root:
            popToRootViewController(animated: animated)
        case .previous:
            popViewController(animated: animated)
        }
    }
}
extension ViewController {
    public var navigation: NavigationController? {
        return navigationController as? NavigationController
    }
    public var previous: ViewController? {
        guard let viewControllers = navigation?.viewControllers,
              let index = viewControllers.firstIndex(of: self),
              viewControllers.count > 1,
              index != 0
        else { return nil }
        return navigation?.viewControllers[index-1] as? ViewController
    }
    public func push(_ viewController: ViewController, animated: Bool = true) {
        navigation?.push(viewController, animated: animated)
    }
    public func back(to distance: NavigationController.Distance = .previous, animated: Bool = true) {
        navigation?.back(to: distance, animated: animated)
    }
}
extension NavigationController: TransitionHandlerDelegate {
    public func will(show controller: Controller) {
        navigationBar.hidden = true
        switch controller {
        case .modern(let controller):
            bar(for: controller)
            controller.tabController?.animate(with: controller, coordinator: transitionCoordinator)
        case .legacy:
            break
        }
    }
    public func did(show controller: Controller) {
        navigationBar.hidden = true
    }
}
extension NavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == pan else { return true }
        let velocity = pan.velocity(in: view)
        switch interaction {
        case .dismiss:
            return velocity.x > 0 || velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
        default:
            return velocity.x > 0 && abs(velocity.x) > abs(velocity.y)
        }
    }
}
extension NavigationController {
    public enum Distance {
        case root
        case previous
    }
}
extension Array where Element == UIViewController {
    public func previous(before viewController: UIViewController) -> UIViewController? {
        guard let viewController = firstIndex(of: viewController), count >= 2 else { return nil }
        return self[index(before: viewController)]
    }
}
