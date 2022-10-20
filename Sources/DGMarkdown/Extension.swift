//
//  Extension.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/9/6.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Markdown
import Foundation

#if canImport(Cocoa)
import Cocoa
#else
import UIKit
#endif

extension Markup {
    
    func isContained<T: Markup>(inMarkupWithType type: T.Type) -> Bool {
        var parent = parent
        while parent != nil {
            if parent is T {
                return true
            }
            parent = parent?.parent
        }
        return false
    }
    
}

extension AttributedString {

    static func blankLine(withLineHeight lineHeight: CGFloat) -> AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        var string = AttributedString(" ")
        string.paragraphStyle = paragraphStyle
        return string
    }

    mutating func appendLineBreak() {
        self.append(AttributedString("\n"))
    }

    mutating func appendBlankLine(withLineHeight lineHeight: CGFloat) {
        self.append(AttributedString("\n"))
        self.append(AttributedString.blankLine(withLineHeight: lineHeight))
        self.append(AttributedString("\n"))
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
    
     func bold() -> NSFont {
         return withTraits( .bold)
     }

     func italic() -> NSFont {
         return withTraits(.italic)
     }

     func noItalic() -> NSFont {
         return withoutTraits(.italic)
     }
    
     func noBold() -> NSFont {
         return withoutTraits(.bold)
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
    
     func bold() -> UIFont {
         return withTraits( .traitBold)
     }

     func italic() -> UIFont {
         return withTraits(.traitItalic)
     }

     func noItalic() -> UIFont {
         return withoutTraits(.traitItalic)
     }
    
     func noBold() -> UIFont {
         return withoutTraits(.traitBold)
     }
    
}
#endif
