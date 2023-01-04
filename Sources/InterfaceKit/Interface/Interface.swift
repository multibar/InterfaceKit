import Nuke
import UIKit
import CoreKit
import DeviceKit
import NukeExtensions

public final class Interface {
    public static let shared = Interface()
    public private(set) lazy var display = CADisplayLink(target: self, selector: #selector(step))
    
    public weak var adaptor: Adaptor? {
        didSet { adaptor?.adapt(display: display) }
    }
    
    internal var pipeline: ImagePipeline = ImagePipeline.shared
    internal var prefetcher: ImagePrefetcher?

    public func initialize() {}
    private init() {
        log(event: "InterfaceKit initialized")
        Core.shared.interface = self
        setup()
    }
    
    private func setup() {
        setupNuke()
        setupDisplayLink()
    }
    private func setupNuke() {
        var configuration = ImagePipeline.Configuration.withDataCache
        configuration.dataCachePolicy = .storeAll
        configuration.dataCache = try? DataCache(name: .disk)
        configuration.isProgressiveDecodingEnabled = false
        pipeline = ImagePipeline(configuration: configuration)
        ImagePipeline.shared = pipeline
        ImageLoadingOptions.shared.pipeline = pipeline
        ImageLoadingOptions.shared.isPrepareForReuseEnabled = false
        ImageLoadingOptions.shared.isProgressiveRenderingEnabled = false
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.2, options: [.curveEaseInOut])
        prefetcher = ImagePrefetcher(pipeline: pipeline, destination: .diskCache)
    }
    private func setupDisplayLink() {
        display.add(to: .current, forMode: .default)
        display.set(fps: .default)
    }
}
extension Interface: InterfaceBridge {
    public var device: String {
        return "\(DeviceKit.Device.current)"
    }
    public func app(state: System.App.State) {}
    public func user(state: System.User.State) {}
}

extension Interface {
    @objc
    private func step(displaylink: CADisplayLink) {
        adaptor?.adapt(display: display)
    }
}
public func display(fps: FPS) {
    Interface.shared.display.set(fps: fps)
}
