import UIKit

public class Constraint {
    public var active: Bool {
        get { constraint?.isActive ?? false }
        set { constraint?.isActive = newValue }
    }
    public var constant: CGFloat {
        get { constraint?.constant ?? 0.0 }
        set { constraint?.constant = newValue }
    }
    internal weak var constraint: NSLayoutConstraint?
    internal required init(constraint: NSLayoutConstraint) {
        self.constraint = constraint
    }
    public required init() {
        self.constraint = nil
    }
}
extension UIView {
    public var auto: Bool {
        get { translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = newValue }
    }
    public var top: NSLayoutYAxisAnchor {
        return topAnchor
    }
    public var safeTop: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }
    public var left: NSLayoutXAxisAnchor {
        return leftAnchor
    }
    public var safeLeft: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leftAnchor
    }
    public var leading: NSLayoutXAxisAnchor {
        return leadingAnchor
    }
    public var safeLeading: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
    }
    public var right: NSLayoutXAxisAnchor {
        return rightAnchor
    }
    public var safeRight: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.rightAnchor
    }
    public var trailing: NSLayoutXAxisAnchor {
        return trailingAnchor
    }
    public var safeTrailing: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.trailingAnchor
    }
    public var bottom: NSLayoutYAxisAnchor {
        return bottomAnchor
    }
    public var safeBottom: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }
    public var centerX: NSLayoutXAxisAnchor {
        return centerXAnchor
    }
    public var safeCenterX: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.centerXAnchor
    }
    public var centerY: NSLayoutYAxisAnchor {
        return centerYAnchor
    }
    public var safeCenterY: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.centerYAnchor
    }
    public var width: NSLayoutDimension {
        return widthAnchor
    }
    public var height: NSLayoutDimension {
        return heightAnchor
    }
    public func line(_ line: Constraint.Line) -> NSLayoutYAxisAnchor {
        switch line {
        case .first: return firstBaselineAnchor
        case .last: return lastBaselineAnchor
        }
    }
    
    @discardableResult
    public func base(line: Constraint.Line,
                     to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                     constant: CGFloat = 0,
                     rule: Constraint.Rule = .equal,
                     priority: UILayoutPriority? = nil,
                     active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch line {
            case .first:
                switch rule {
                case .equal: return firstBaselineAnchor.constraint(equalTo: anchor, constant: constant)
                case .less: return firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
                case .more: return firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
                }
            case .last:
                switch rule {
                case .equal: return lastBaselineAnchor.constraint(equalTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
                case .less: return lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
                case .more: return lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
                }
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func top(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                    constant: CGFloat = 0,
                    rule: Constraint.Rule = .equal,
                    priority: UILayoutPriority? = nil,
                    active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return topAnchor.constraint(equalTo: anchor, constant: constant)
            case .less: return topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
            case .more: return topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func left(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                     constant: CGFloat = 0,
                     rule: Constraint.Rule = .equal,
                     priority: UILayoutPriority? = nil,
                     active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return leftAnchor.constraint(equalTo: anchor, constant: constant)
            case .less: return leftAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
            case .more: return leftAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func leading(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        constant: CGFloat = 0,
                        rule: Constraint.Rule = .equal,
                        priority: UILayoutPriority? = nil,
                        active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return leadingAnchor.constraint(equalTo: anchor, constant: constant)
            case .less: return leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
            case .more: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func right(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                      constant: CGFloat = 0,
                      rule: Constraint.Rule = .equal,
                      priority: UILayoutPriority? = nil,
                      active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return rightAnchor.constraint(equalTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .less: return rightAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .more: return rightAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func trailing(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                         constant: CGFloat = 0,
                         rule: Constraint.Rule = .equal,
                         priority: UILayoutPriority? = nil,
                         active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return trailingAnchor.constraint(equalTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .less: return trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .more: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func bottom(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                       constant: CGFloat = 0,
                       rule: Constraint.Rule = .equal,
                       priority: UILayoutPriority? = nil,
                       active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return bottomAnchor.constraint(equalTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .less: return bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            case .more: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant < 0.0 ? abs(constant) : -constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func centerX(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                        constant: CGFloat = 0,
                        rule: Constraint.Rule = .equal,
                        priority: UILayoutPriority? = nil,
                        active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return centerXAnchor.constraint(equalTo: anchor, constant: constant)
            case .less: return centerXAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
            case .more: return centerXAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func centerY(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                        constant: CGFloat = 0,
                        rule: Constraint.Rule = .equal,
                        priority: UILayoutPriority? = nil,
                        active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return centerYAnchor.constraint(equalTo: anchor, constant: constant)
            case .less: return centerYAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
            case .more: return centerYAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func width(to anchor: NSLayoutDimension,
                      multiplier: CGFloat = 1,
                      constant: CGFloat = 0,
                      rule: Constraint.Rule = .equal,
                      priority: UILayoutPriority? = nil,
                      active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .less: return widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .more: return widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func width(_ constant: CGFloat,
                      priority: UILayoutPriority? = nil,
                      active: Bool = true) -> Constraint {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func height(to anchor: NSLayoutDimension,
                       multiplier: CGFloat = 1,
                       constant: CGFloat = 0,
                       rule: Constraint.Rule = .equal,
                       priority: UILayoutPriority? = nil,
                       active: Bool = true) -> Constraint {
        let constraint: NSLayoutConstraint = {
            switch rule {
            case .equal: return heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .less: return heightAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .more: return heightAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            }
        }()
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    @discardableResult
    public func height(_ constant: CGFloat,
                       priority: UILayoutPriority? = nil,
                       active: Bool = true) -> Constraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        if let priority { constraint.priority = priority }
        constraint.isActive = active
        return Constraint(constraint: constraint)
    }
    
    public func box(in view: UIView, inset: CGFloat, safe: Bool = false) {
        box(in: view, insets: .insets(all: inset), safe: safe)
    }
    public func box(in view: UIView, insets: UIEdgeInsets = .zero, safe: Bool = false) {
        topAnchor.constraint(equalTo: safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: insets.top).isActive = true
        rightAnchor.constraint(equalTo: safe ? view.safeAreaLayoutGuide.rightAnchor : view.rightAnchor , constant: -insets.right).isActive = true
        leftAnchor.constraint(equalTo: safe ? view.safeAreaLayoutGuide.leftAnchor : view.leftAnchor, constant: insets.left).isActive = true
        bottomAnchor.constraint(equalTo: safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    public func `repeat`(_ view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    public func center(in view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    public func center(in view: UIView, with size: CGSize) {
        center(in: view)
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    public func center(in view: UIView, ratio: CGFloat) {
        center(in: view)
        widthAnchor.constraint(equalToConstant: ratio).isActive = true
        heightAnchor.constraint(equalToConstant: ratio).isActive = true
    }
    public func aspect(ratio: CGFloat) {
        widthAnchor.constraint(equalToConstant: ratio).isActive = true
        heightAnchor.constraint(equalToConstant: ratio).isActive = true
    }
    public func size(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    public func size(of view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension Constraint {
    public enum Line {
        case first
        case last
    }
    public enum Rule {
        case equal
        case less
        case more
    }
}
