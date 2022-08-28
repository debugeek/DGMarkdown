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

    let font: NSFont
    let paragraphStyle: NSParagraphStyle
    let foregroundColor: NSColor
    let backgroundColor: NSColor
    let strikethrough: Bool
    
    init(font: NSFont,
         paragraphStyle: NSParagraphStyle = .init(),
         foregroundColor: NSColor = .textColor,
         backgroundColor: NSColor = .clear,
         strikethrough: Bool = false) {
        self.font = font
        self.paragraphStyle = paragraphStyle
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.strikethrough = strikethrough
    }

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
    
    static var body: Style {
        return Style(font: NSFont.systemFont(ofSize: 16))
    }
    
    static var emphasis: Style {
        return Style(font: NSFontManager.shared.convert(NSFont.systemFont(ofSize: 16), toHaveTrait: .italicFontMask))
    }
    
    static var strong: Style {
        return Style(font: NSFont.systemFont(ofSize: 16, weight: .bold))
    }
    
    static var strikethrough: Style {
        return Style(font: NSFont.systemFont(ofSize: 16),
                     strikethrough: true)
    }
    
}
