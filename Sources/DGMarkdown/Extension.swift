//
//  Extension.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/9/6.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation

#if canImport(Cocoa)
import Cocoa
#else
import UIKit
#endif

extension NSMutableAttributedString {

    func mergeAttributes(_ attrs: [NSAttributedString.Key: Any], range: NSRange? = nil) {
        let range = range ?? NSRange(0..<length)
        for (key, newValue) in attrs {
            enumerateAttribute(key, in: range) { oldValue, range, _ in
                if oldValue == nil {
                    addAttribute(key, value: newValue, range: range)
                } else {
                    if let newFont = newValue as? Font, let oldFont = oldValue as? Font {
                        var font = newFont.pointSize > oldFont.pointSize ? newFont : oldFont
                        if newFont.isBold() || oldFont.isBold() {
                            font = font.withBold()
                        }
                        if newFont.isItalic() || oldFont.isItalic() {
                            font = font.withItalic()
                        }
                        addAttribute(key, value: font, range: range)
                    } else {
                        addAttribute(key, value: newValue, range: range)
                    }
                }
            }
        }
    }
    
    func appendLineBreak() {
        self += "\n"
    }

    func appendBlankLine(withLineHeight lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        let string = NSMutableAttributedString("")
        string.appendLineBreak()
        string.setAttributes([.paragraphStyle: paragraphStyle], range: NSRange(0..<string.length))
        self += string
    }
    
    static func += (lhs: NSMutableAttributedString, rhs: NSAttributedString) {
        lhs.append(rhs)
    }
    
    static func += (lhs: NSMutableAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    static func += (lhs: NSMutableAttributedString, rhs: AttributedString) {
        lhs += NSAttributedString(rhs)
    }
    
}

#if canImport(Cocoa)
extension NSFont {
    
    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits ...) -> NSFont {
        let fontDescriptor = fontDescriptor.withSymbolicTraits(NSFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits))
        return NSFont(descriptor: fontDescriptor, size: 0) ?? self
    }
    
    func withoutTraits(_ traits: NSFontDescriptor.SymbolicTraits ...) -> NSFont {
        let fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.subtracting(NSFontDescriptor.SymbolicTraits(traits)))
        return NSFont(descriptor: fontDescriptor, size: 0) ?? self
    }
    
    func isBold() -> Bool {
        return fontDescriptor.symbolicTraits.contains(.bold)
    }
    
    func withBold() -> NSFont {
        return withTraits(.bold)
    }

    func withoutBold() -> NSFont {
        return withoutTraits(.bold)
    }

    func isItalic() -> Bool {
        return fontDescriptor.symbolicTraits.contains(.italic)
    }
    
    func withItalic() -> NSFont {
        return withTraits(.italic)
    }

    func withoutItalic() -> NSFont {
        return withoutTraits(.italic)
    }
    
}
#else
extension UIFont {
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits ...) -> UIFont {
        guard let fontDescriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: fontDescriptor, size: 0)
     }
    
    func withoutTraits(_ traits: UIFontDescriptor.SymbolicTraits ...) -> UIFont {
        guard let fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
    
    func isBold() -> Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    func withBold() -> UIFont {
        return withTraits(.traitBold)
    }
    
    func withoutBold() -> UIFont {
        return withoutTraits(.traitBold)
    }
    
    func isItalic() -> Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func withItalic() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    func withoutItalic() -> UIFont {
        return withoutTraits(.traitItalic)
    }
    
}
#endif
