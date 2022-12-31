import UIKit

open class Media: UIImageView {
    public internal(set) weak var parent: MediaView?
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    public override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: image)
        setup()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func setup() {}
}

extension Media {
    public var outcasted: Bool {
        return parent?.media != self
    }
}
