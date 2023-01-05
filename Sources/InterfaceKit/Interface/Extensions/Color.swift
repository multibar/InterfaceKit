import UIKit

extension UIColor {
    public static let x000000    = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public static let x095B6D    = #colorLiteral(red: 0.03529411765, green: 0.3568627451, blue: 0.4274509804, alpha: 1)
    public static let x1F2633    = #colorLiteral(red: 0.1215686275, green: 0.1490196078, blue: 0.2, alpha: 1)
    public static let x151A26    = #colorLiteral(red: 0.08235294118, green: 0.1019607843, blue: 0.1490196078, alpha: 1)
    public static let x5CC489    = #colorLiteral(red: 0.3607843137, green: 0.768627451, blue: 0.537254902, alpha: 1)
    public static let x58ABF5    = #colorLiteral(red: 0.3450980392, green: 0.6705882353, blue: 0.9607843137, alpha: 1)
    public static let x8B93A1    = #colorLiteral(red: 0.5450980392, green: 0.5764705882, blue: 0.631372549, alpha: 1)
    public static let x8B93A1_05 = #colorLiteral(red: 0.5450980392, green: 0.5764705882, blue: 0.631372549, alpha: 0.05)
    public static let x8B93A1_20 = #colorLiteral(red: 0.5450980392, green: 0.5764705882, blue: 0.631372549, alpha: 0.2)
    public static let xEEEFEF    = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.937254902, alpha: 1)
    public static let xFFFFFF    = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let xFFFFFF_05 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
    public static let xFFFFFF_20 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
    public static let xF36655    = #colorLiteral(red: 0.9529411765, green: 0.4, blue: 0.3333333333, alpha: 1)
}

// MARK: - Hex Color
extension UIColor {
    public convenience init?(hex: String?) {
        guard let hex = hex else { return nil }
        self.init(hex: hex)
    }
    public convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        let length = hexSanitized.count
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    public var hex: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    public var invisible: Bool {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return a == 0
    }
    public var light: Bool {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1_000
        return brightness >= 0.5
    }
    public static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

extension String {
    public var hex: UIColor {
        return UIColor(hex: self)
    }
}
