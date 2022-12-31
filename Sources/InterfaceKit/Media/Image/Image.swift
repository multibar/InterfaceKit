import Nuke
import UIKit
import CoreKit
import NukeExtensions

public class Image: Media {
    public private(set) var source: URL?
    public private(set) var format: View.Format = .auto
    public private(set) var style: Style = .none {
        didSet {
            contentMode = style == .none ? .scaleAspectFit : .redraw
        }
    }
    internal func load(from source: URL?,
                       with format: View.Format,
                       with style: Style,
                       placeholder: UIImage? = nil,
                       force transition: Bool,
                       completion: @escaping (UIImage?) -> Void = {_ in}) {
        guard let source else {
            completion(nil)
            return
        }
        Task {
            await MainActor.run {
                self.source = source
                self.format = format
                self.style = style
                var options = style.options
                options.alwaysTransition = transition
                options.placeholder = placeholder
                options.failureImage = placeholder
                loadImage(with: source, options: options, into: self, completion: { [weak self] result in
                    Task { await MainActor.run {self?.parent?.loaded()}}
                    switch result {
                    case .success(let response):
                        //                    switch response.cacheType {
                        //                    case .disk  : log(event: "Fetched: \(source), source: disk", source: .images)
                        //                    case .memory: log(event: "Fetched: \(source), source: memory", source: .images)
                        //                    default     : log(event: "Fetched: \(source), source: memory", source: .images)
                        //                    }
                        completion(response.image)
                    case .failure(let failure):
                        log(event: "Failed to fetch: \(source), error: \(failure.description)", source: .images)
                        completion(nil)
                    }
                })
            }
        }
    }
}
extension Image {
    public var cornerRadius: CGFloat {
        switch style {
        case .rounded(let radius, _):
            return radius
        case .circle(let size):
            return size.height / 2
        default:
            return 0
        }
    }
}
extension Image {
    public enum Style: Equatable {
        case none
        case resize(to: CGSize)
        case rounded(radius: CGFloat, size: CGSize)
        case circle(size: CGSize)
        
        internal var options: ImageLoadingOptions {
            var options = ImageLoadingOptions.shared
            options.processors = processors
            return options
        }
        internal var processors: [ImageProcessing] {
            switch self {
            case .none:
                return []
            case .resize(let size):
                return [ImageProcessors.Resize(size: size, crop: true)]
            case .rounded(let radius, let size):
                return [ImageProcessors.Resize(size: size, crop: true), Rounded(radius: radius, size: size)]
            case .circle(let size):
                return [ImageProcessors.Resize(size: size, crop: true), ImageProcessors.Circle()]
            }
        }
    }
}
extension Image {
    public struct Rounded: ImageProcessing, Hashable {
        private var radius: CGFloat
        private var size: CGSize
        public var identifier: String {
            return "com.mediakit.processors.rounded.radius=\(radius)&size=w\(size.width)h=\(size.height)"
        }
        public init(radius: CGFloat, size: CGSize) {
            self.radius = radius
            self.size = size
        }
        public func process(_ image: PlatformImage) -> PlatformImage? {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let rect = CGRect(origin: .zero, size: image.size)
            UIBezierPath.continuousRoundedRect(rect, cornerRadius: radius).addClip()
            image.draw(in: rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
    }
}
extension Image.Rounded {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(radius)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}
