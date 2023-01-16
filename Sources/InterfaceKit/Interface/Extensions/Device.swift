import CoreKit
import DeviceKit
import Foundation

extension System.Device {
    public static let current = Device.current
    public static let island: Bool = {
        switch current {
        case .iPhone14ProMax, .iPhone14Pro:
            return true
        default:
            return false
        }
    }()
}
