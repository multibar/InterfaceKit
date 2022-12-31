import UIKit
import CoreKit

public struct Attributes {
    public let typography: Typography
    public let color: UIColor
    
    public init(typography: Typography = Typography(), color: UIColor? = .x000000) {
        self.typography = typography
        self.color = color ?? .x000000
    }
    
    public struct Typography {
        public let font          : UIFont
        public let alignment     : NSTextAlignment
        public let lineBreakMode : NSLineBreakMode?
        public let strikethrough : Bool
        public let hyphens       : Bool
        public let spacing       : Spacing
        
        public init(font         : UIFont = .systemFont(ofSize: 12, weight: .semibold),
                    alignment    : NSTextAlignment = .left,
                    lineBreakMode: NSLineBreakMode? = .byTruncatingTail,
                    strikethrough: Bool = false,
                    hyphens      : Bool = false,
                    spacing      : Spacing = Spacing(line: 12, char: 0)) {
            self.font            = font
            self.alignment       = alignment
            self.lineBreakMode   = lineBreakMode
            self.strikethrough   = strikethrough
            self.hyphens         = hyphens
            self.spacing         = spacing
        }

        public struct Spacing {
            public let line: CGFloat
            public let char: CGFloat
            
            public init(line: CGFloat, char: CGFloat) {
                self.line = line
                self.char = char
            }
            
            public static var zero: Spacing {
                return Spacing(line: 0, char: 0)
            }
            public static func spacing(line: CGFloat, char: CGFloat) -> Spacing {
                return Spacing(line: line, char: char)
            }
        }
    }
}

extension Attributes: Equatable {
    public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
        lhs.typography.font          == rhs.typography.font          ||
        lhs.typography.alignment     == rhs.typography.alignment     ||
        lhs.typography.lineBreakMode == rhs.typography.lineBreakMode ||
        lhs.typography.strikethrough == rhs.typography.strikethrough ||
        lhs.typography.hyphens       == rhs.typography.hyphens       ||
        lhs.typography.spacing.line  == rhs.typography.spacing.line  ||
        lhs.typography.spacing.char  == rhs.typography.spacing.char  ||
        lhs.color                    == rhs.color
    }
}
extension Attributes {
    public static let `default` = Attributes()
}
