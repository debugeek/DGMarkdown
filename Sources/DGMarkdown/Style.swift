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
        return Style(font: NSFont.systemFont(ofSize: 16, weight: .light))
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
        return Style(font: NSFont.monospacedSystemFont(ofSize: 11, weight: .regular),
                     backgroundColor: .lightGray)
    }
    
    static var codeBlock: Style {
        return Style(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                     backgroundColor: .lightGray)
    }
    
    static var listItem1: Style {
        return Style(font: NSFont.systemFont(ofSize: 16, weight: .medium))
    }
    
    static var listItem2: Style {
        return Style(font: NSFont.systemFont(ofSize: 14, weight: .medium))
    }
    
    static var listItem3: Style {
        return Style(font: NSFont.systemFont(ofSize: 12, weight: .medium))
    }
    
    static var listItem4: Style {
        return Style(font: NSFont.systemFont(ofSize: 10, weight: .medium))
    }
    
    static var thematicBreak: Style {
        return Style(font: NSFont.systemFont(ofSize: 16),
                     foregroundColor: .lightGray)
    }
    
    static var tableHead: Style {
        return Style(font: NSFont.monospacedSystemFont(ofSize: 14, weight: .medium))
    }
    
    static var tableCell: Style {
        return Style(font: NSFont.monospacedSystemFont(ofSize: 14, weight: .thin))
    }
    
}
