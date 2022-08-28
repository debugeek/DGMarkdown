//
//  Style.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Cocoa
import Markdown

struct Style {

    var font: NSFont
    var paragraphStyle: NSParagraphStyle = .init()
    var foregroundColor: NSColor = .textColor
    var backgroundColor: NSColor = .clear
    
}

extension Style {

    static var h1: Style {
        return Style(font: NSFont.systemFont(ofSize: 32, weight: .heavy))
    }
    
    static var h2: Style {
        return Style(font: NSFont.systemFont(ofSize: 28, weight: .bold))
    }
    
    static var h3: Style {
        return Style(font: NSFont.systemFont(ofSize: 24, weight: .semibold))
    }
    
    static var h4: Style {
        return Style(font: NSFont.systemFont(ofSize: 20, weight: .medium))
    }
    
    static var text: Style {
        return Style(font: NSFont.systemFont(ofSize: 16))
    }
    
    static var link: Style {
        return Style(font: NSFont.systemFont(ofSize: 16, weight: .light))
    }
    
    static var emphasis: Style {
        return Style(font: NSFontManager.shared.convert(NSFont.systemFont(ofSize: 16), toHaveTrait: .italicFontMask))
    }
    
    static var strong: Style {
        return Style(font: NSFont.systemFont(ofSize: 16, weight: .bold))
    }
    
    static var strikethrough: Style {
        return Style(font: NSFont.systemFont(ofSize: 16))
    }
    
    static var inlineCode: Style {
        return Style(font: NSFont.systemFont(ofSize: 16),
                     backgroundColor: .gray)
    }
    
}
