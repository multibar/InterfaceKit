import UIKit
import CoreKit

public protocol ViewController: UIViewController, Router {
    /// Unique controller identifier.
    var identifier: UUID { get }
    
    /// Controller initial route.
    var route: Route { get }
    
    /// Navigation Bar optional instance. Will be nil if items are empty.
    var navBar: NavigationController.Bar? { get set }
    
    /// Navigation Bar style customization.
    var navBarStyle: NavigationController.Bar.Style { get }
    
    /// Navitaion Bar items.
    var navBarItems: [NavigationController.Bar.Item] { get }
    
    /// If true, Navigation Bar will be hidden.
    var navBarHidden: Bool { get }
    
    /// If true, present and dismiss animated transitions will compensate Navigation Bar Height.
    var navBarOffsets: Bool { get }
    
    /// If true, will be presented anyway.
    var forcePresent: Bool { get }
    
    /// Transition container A.
    var containerA: Container? { get }
    
    /// Transition container B.
    var containerB: Container? { get }
    
    /// If false, multibar will be hidden for this controller.
    var multibar: Bool { get }
    
    /// Controller content view.
    var content: UIView { get }
    
    /// Controller scroll view.
    var scroll: UIScrollView? { get }
    
    /// Controller view's color.
    var color: UIColor { get }
    
    func app(state: System.App.State)
    func user(state: System.User.State)
    func update(traits: UITraitCollection)
    func process(route: Route)
    func prepare()
    func rebuild()
    func destroy()
}
public protocol Container: UIView {
    var identifier: UUID { get }
    var transaction: UUID? { get set }
    var cargo: UIView { get set }
    var format: View.Format { get set }
    var adaptive: Bool { get }
    var ratio: CGFloat { get }
    func will(accept cargo: UIView)
    func loaded()
    func rebuild()
    func destroy()
}
extension ViewController {
    public static func ==(lhs: ViewController, rhs: ViewController) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.route == rhs.route
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(route)
    }
}
extension ViewController {
    public var navBarOffsets: Bool {
        return false
    }
    public var presented: ViewController? {
        return presentedViewController as? ViewController
    }
    public var presenting: ViewController? {
        return presentingViewController as? ViewController
    }
}
extension Container {
    public var ratio: CGFloat {
        return bounds.width / bounds.height
    }
}
extension UIViewController {
    public var traits: UITraitCollection {
        return traitCollection
    }
    public func relayout() {
        view.relayout()
    }
}
extension UIViewController {
    public func presentable(to controller: UIViewController) -> Bool {
        guard let controllerA = controller as? ViewController,
              let controllerB = self as? ViewController
        else { return false }
        guard let containerA = controllerA.containerA,
              let containerB = controllerB.containerB
        else { return controllerA.forcePresent }
        if containerA.adaptive { containerA.format = containerB.format}
        return true
    }
    public func dismissable(to controller: UIViewController) -> Bool {
        guard let controllerA = self as? ViewController,
              let controllerB = controller as? ViewController
        else { return false }
        guard let containerA = controllerA.containerA,
              let containerB = controllerB.containerB
        else { return controllerA.forcePresent }
        if containerA.adaptive { containerA.format = containerB.format }
        return true
    }
}
