import UIKit
import CoreKit

open class TabController: UIViewController, ViewController {
    private var selected: UIView? {
        didSet {
            oldValue?.remove()
            guard let selected else { return }
            selected.frame = view.bounds
            selected.auto = false
            content.insert(selected, at: 0)
            selected.box(in: content)
            view.relayout()
        }
    }
    
    public let identifier = UUID()
    public let content = UIView()
    
    open var route: Route {
        return viewController?.route ?? .none
    }
    open var forcePresent: Bool {
        return false
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
    open var scroll: UIScrollView? {
        return viewController?.scroll
    }

    #if os(iOS)
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    open override var shouldAutorotate: Bool {
        return viewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    open override var prefersStatusBarHidden: Bool {
        return viewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return viewController?.prefersHomeIndicatorAutoHidden ?? super.prefersHomeIndicatorAutoHidden
    }
    #endif
    
    open var viewController: ViewController? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
            guard let viewController = viewController,
                    viewControllers.contains(where: {$0.identifier == viewController.identifier}),
                    oldValue?.route != viewController.route
            else { return }
            selected = viewController.view
            animate(with: viewController)
        }
    }
    open var viewControllers: [ViewController] = [] {
        didSet {
            oldValue.forEach({
                $0.willMove(toParent: nil)
                $0.view.remove()
                $0.removeFromParent()
            })
            viewController = nil
            guard !viewControllers.empty else { return }
            viewControllers.forEach({
                addChild($0)
                $0.view.frame = view.bounds
                $0.didMove(toParent: self)
            })
            viewController = viewControllers.first
        }
    }
    open var navBar: NavigationController.Bar? {
        get { viewController?.navBar }
        set { viewController?.navBar = newValue }
    }
    open var navBarStyle: NavigationController.Bar.Style {
        return viewController?.navBarStyle ?? .none
    }
    open var navBarItems: [NavigationController.Bar.Item] {
        return viewController?.navBarItems ?? []
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    open func setupContent() {
        content.auto = false
        view.insert(content, at: 0)
        content.box(in: view)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        update(traits: traits)
    }
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (coordinator) in
            self.update(traits: self.traits)
        }, completion: nil)
    }
    open func animate(with viewController: ViewController, coordinator: UIViewControllerTransitionCoordinator? = nil) {}
    open func app(state: System.App.State) {}
    open func user(state: System.User.State) {}
    open func update(traits: UITraitCollection) {
        viewControllers.forEach({$0.update(traits: traits)})
    }
    open func process(route: Route) {
        guard let selected = viewControllers.first(where: {$0.rootRoute == route}) else {
            viewController?.process(route: route)
            return
        }
        guard viewController?.route != route else {
            viewController?.scroll?.offset(to: .point(x: 0, y: -(scroll?.insets.top ?? 0)))
            return
        }
        guard viewController?.rootRoute != route else {
            (viewController as? NavigationController)?.back()
            return
        }
        viewController = selected
    }
    open func prepare() {}
    open func rebuild() {}
    open func destroy() {}
}

extension ViewController {
    public var tabController: TabController? {
        return parent as? TabController ?? navigation?.tabController
    }
    public var rootRoute: Route? {
        if let self = self as? NavigationController {
            return self.rootViewController.route
        } else {
            return navigation?.rootViewController.route ?? route
        }
    }
}
