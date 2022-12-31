import UIKit
import CoreGraphics

extension UIImage {
    public static func pdf(from url: URL?) -> UIImage? {
        guard let url = url,
              let document = CGPDFDocument(url as CFURL),
              let page = document.page(at: 1)
        else { return nil }
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.clear.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            ctx.cgContext.drawPDFPage(page)
        }
        return img
    }
}
