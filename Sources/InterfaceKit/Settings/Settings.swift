import UIKit
import CoreKit

extension Settings {
    public struct Interface {
        public struct TabBar {}
    }
}

extension Settings.Interface.TabBar {
    public static var selectedIndex: Int {
        get {
            return Settings.get(value: Int.self, for: Settings.Keys.Interface.TabBar.selectedIndex) ?? 0
        } set {
            Settings.set(value: newValue, for: Settings.Keys.Interface.TabBar.selectedIndex)
        }
    }
}
