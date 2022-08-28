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

}

extension Style {

    static var h1: Style {
        return Style(font: NSFont.systemFont(ofSize: 32, weight: .heavy),
                     paragraphStyle: NSParagraphStyle(),
                     foregroundColor: NSColor.textColor,
                     backgroundColor: NSColor.clear)
    }
    
    static var h2: Style {
        return Style(font: NSFont.systemFont(ofSize: 28, weight: .bold),
                     paragraphStyle: NSParagraphStyle(),
                     foregroundColor: NSColor.textColor,
                     backgroundColor: NSColor.clear)
    }
    
    static var h3: Style {
        return Style(font: NSFont.systemFont(ofSize: 24, weight: .semibold),
                     paragraphStyle: NSParagraphStyle(),
                     foregroundColor: NSColor.textColor,
                     backgroundColor: NSColor.clear)
    }
    
    static var h4: Style {
        return Style(font: NSFont.systemFont(ofSize: 20, weight: .medium),
                     paragraphStyle: NSParagraphStyle(),
                     foregroundColor: NSColor.textColor,
                     backgroundColor: NSColor.clear)
    }
    
    static var body: Style {
        return Style(font: NSFont.systemFont(ofSize: 16),
                     paragraphStyle: NSParagraphStyle(),
                     foregroundColor: NSColor.textColor,
                     backgroundColor: NSColor.clear)
    }
    
}
