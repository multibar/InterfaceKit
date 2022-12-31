import UIKit
import CoreKit

public protocol ViewController: UIViewController, Router {
    var identifier   : UUID { get }
    var route        : Route { get }
    var navBar       : NavigationController.Bar? { get set }
    var navBarStyle  : NavigationController.Bar.Style { get }
    var navBarItems  : [NavigationController.Bar.Item] { get }
    var navBarOffsets: Bool { get }
    var forcePresent : Bool { get }
    var containerA   : Container? { get }
    var containerB   : Container? { get }
    var multibar     : Bool { get }
    var content      : UIView { get }
    var scroll       : UIScrollView? { get }
    func app(state: System.App.State)
    func user(state: System.User.State)
    func update(trait collection: UITraitCollection)
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
    var cornerRadius: CGFloat { get }
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
        return true
    }
    public var hasNavBar: Bool {
        return !navBarItems.empty || navigation?.rootViewController != self
    }
}
extension Container {
    public var cornerRadius: CGFloat {
        return layer.cornerRadius
    }
    public var ratio: CGFloat {
        return bounds.width / bounds.height
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
