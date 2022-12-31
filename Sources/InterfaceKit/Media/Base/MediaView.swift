import UIKit
import CoreKit

open class MediaView: UIView {
    public let identifier = UUID()
    public var transaction: UUID?
    private var _media: Media
    final public var media: Media {
        get { return _media }
        set { process(media: newValue, old: _media) }
    }
    open var format: View.Format
    open var prefersAdaptivity = false
    open var adaptive: Bool {
        return prefersAdaptivity
    }
    
    public init(media: Media = Media(), format: View.Format, frame: CGRect = .zero) {
        self._media = media
        self.format = format
        super.init(frame: frame)
        setup()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        layout()
    }
    
    ///Called when media is about to change.
    open func process(media new: Media, old: Media) {
        old.remove()
        _media = new
        layout()
    }
    open func will(accept media: Media) {}
    open func layout() {
        media.auto = false
        insert(media, at: 0)
        media.box(in: self)
    }
    
    ///Called when media has loaded it's content and is ready to be displayed.
    open func loaded() {}
    ///Called when rebuild operation is necessary.
    open func rebuild() {}
    ///Called right before being destroyed.
    open func destroy() {}
}

extension MediaView: Container {
    public var cargo: UIView {
        get { media }
        set {
            guard let media = newValue as? Media else { return }
            self.media = media
        }
    }
    public func will(accept cargo: UIView) {
        guard let media = cargo as? Media else { return }
        self.will(accept: media)
    }
}
