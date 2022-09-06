//
//  Extension.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/9/6.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Markdown
import Cocoa

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
    
    static func blankLine(withHeight height: CGFloat) -> AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.maximumLineHeight = height
        
        var lineBreak = AttributedString(" ")
        lineBreak.paragraphStyle = paragraphStyle
        return lineBreak
    }
    
    func appendingBlankLine(withHeight height: CGFloat) -> AttributedString {
        return self + "\n" + .blankLine(withHeight: height) + "\n"
    }
    
}
