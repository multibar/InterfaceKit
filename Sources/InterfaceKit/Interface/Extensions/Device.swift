import CoreKit
import DeviceKit
import Foundation

extension System.Device {
    public static let hasDynamicIsland: Bool = {
        switch Device.current {
        case .iPhone14ProMax, .iPhone14Pro:
            return true
        default:
            return false
        }
    }()
}
