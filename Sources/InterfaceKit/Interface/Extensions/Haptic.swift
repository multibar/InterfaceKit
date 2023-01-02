import UIKit

#if os(iOS)
public enum Haptic {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
    case prepare
    
    public static func prepare() {
        Haptic.prepare.generate()
    }
    public func generate() {
        switch self {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case .prepare:
            let generator = UIImpactFeedbackGenerator()
            generator.prepare()
        }
    }
}
#endif
