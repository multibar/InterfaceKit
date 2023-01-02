import Foundation
import QuartzCore

public protocol Adaptor: AnyObject {
    func adapt(display: CADisplayLink)
}

extension CADisplayLink {
    public func set(fps: FPS) {
        switch fps {
        case .default:
            if #available(iOS 15.0, *) {
                preferredFrameRateRange = fps.framerate
            } else {
                preferredFramesPerSecond = 0
            }
        default:
            if #available(iOS 15.0, *) {
                preferredFrameRateRange = fps.framerate
            } else {
                preferredFramesPerSecond = fps._framerate
            }
        }
    }
}
public enum FPS {
    /// 120 FPS
    case maximum
    /// 60 FPS
    case `default`
    /// 30 FPS
    case lowered
    /// 24 FPS
    case cinema
    /// 10 FPS
    case minimum
    /// Custom specified
    case explicit(minimum: Float, maximum: Float, preferred: Float)
    
    @available(iOS 15.0, *)
    internal var framerate: CAFrameRateRange {
        switch self {
        case .maximum:
            return CAFrameRateRange(minimum: 80, maximum: 120, preferred: 120)
        case .lowered:
            return CAFrameRateRange(minimum: 30, maximum: 48, preferred: 48)
        case .cinema:
            return CAFrameRateRange(minimum: 24, maximum: 30, preferred: 30)
        case .minimum:
            return CAFrameRateRange(minimum: 8, maximum: 15, preferred: 15)
        case .explicit(let minimum, let maximum, let preferred):
            return CAFrameRateRange(minimum: minimum, maximum: maximum, preferred: preferred)
        case .default:
            return CAFrameRateRange.default
        }
    }
    internal var _framerate: Int {
        switch self {
        case .maximum:
            return 120
        case .lowered:
            return 48
        case .cinema :
            return 30
        case .minimum:
            return 24
        case .explicit(_, _, let preferred):
            return Int(preferred)
        case .default:
            return 0
        }
    }
}
