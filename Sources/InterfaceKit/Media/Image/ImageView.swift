import UIKit
import CoreKit

public class ImageView: MediaView {
    public var _image: Image? { return media as? Image }
    public var style: Image.Style
    public var source: URL?
    
    private weak var retained: ImageView?
    
    public required init(format: View.Format = .auto) {
        self.style = .none
        super.init(media: Image(), format: format)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func process(media new: Media, old: Media) {
        if new is Image { super.process(media: new, old: old) }
        media.alpha = 1.0
        retained = new.parent as? ImageView
        guard _image?.format != format || _image?.style != style else { return }
        load(from: _image?.source, force: true)
    }
    public override func rebuild() {
        super.rebuild()
        let image = Image()
        self.media = image
        image.load(from: source,
                   with: format,
                   with: style,
                   force: false)
    }
    public override func destroy() {
        super.destroy()
        guard let retained = retained else { return }
        _image?.load(from: _image?.source,
                    with: retained.format,
                    with: retained.style,
                    placeholder: nil,
                    force: true)
    }
    public func load(from source: URL?,
                     with style: Image.Style? = nil,
                     placeholder: UIImage? = nil,
                     force transition: Bool = false,
                     completion: @escaping (UIImage?) -> Void = {_ in}) {
        if let style = style { self.style = style }
        if let source = source { self.source = source }
        let placeholder = _image?.source == source ? nil : placeholder
        _image?.load(from: source,
                    with: format,
                    with: style ?? self.style,
                    placeholder: placeholder,
                    force: transition,
                    completion: completion)
    }
}
extension ImageView {
    public var image: UIImage? {
        get { _image?.image }
        set { _image?.image = newValue }
    }
    public func clear() {
        _image?.clear()
    }
}
extension UIImageView {
    public func clear() {
        image = nil
    }
}
