//
//  Style.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Markdown
import DGExtension

#if canImport(Cocoa)
import Cocoa
typealias Font = NSFont
typealias Color = NSColor
#else
import UIKit
typealias Font = UIFont
typealias Color = UIColor
#endif

public struct Style {
    
    #if canImport(Cocoa)
    var textColor = NSColor.textColor
    #else
    var textColor = UIColor.label
    #endif
    
    var document: DocumentStyle
    var paragraph: ParagraphStyle
    
    var text: TextStyle
    var h1: HeadingStyle
    var h2: HeadingStyle
    var h3: HeadingStyle
    var h4: HeadingStyle
    var link: LinkStyle
    var strong: StrongStyle
    var inlineCode: InlineCodeStyle
    var codeBlock: CodeBlockStyle
    var listItem: ListItemStyle
    var thematicBreak: ThematicBreakStyle
    var tableHead: TableHeadStyle
    var tableCell: TableCellStyle
    var blockQuote: BlockQuoteStyle
    var softBreak: SoftBreakStyle
    
    public init() {
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            document = DocumentStyle(paragraphStyle: paragraphStyle)
        }
        
        do {
            paragraph = ParagraphStyle(lineBreakHeight: 12)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            text = TextStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular),
                             paragraphStyle: paragraphStyle,
                             foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h1 = HeadingStyle(font: Font.monospacedSystemFont(ofSize: 32, weight: .heavy),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 14)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h2 = HeadingStyle(font: Font.monospacedSystemFont(ofSize: 28, weight: .bold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 10)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h3 = HeadingStyle(font: Font.monospacedSystemFont(ofSize: 24, weight: .semibold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 8)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h4 = HeadingStyle(font: Font.monospacedSystemFont(ofSize: 20, weight: .medium),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 4)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            link = LinkStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .light),
                             paragraphStyle: paragraphStyle,
                             foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            strong = StrongStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .bold),
                                 paragraphStyle: paragraphStyle,
                                 foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            inlineCode = InlineCodeStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular),
                                         paragraphStyle: paragraphStyle,
                                        foregroundColor: Color.color(withHex: 0xFFFFFF, alpha: 0.85),
                                         backgroundColor: Color.color(withHex: 0x161616))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            codeBlock = CodeBlockStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular),
                                       paragraphStyle: paragraphStyle,
                                       foregroundColor: Color.color(withHex: 0xFFFFFF, alpha: 0.85),
                                       backgroundColor: Color.color(withHex: 0x161616))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            listItem = ListItemStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular),
                                     paragraphStyle: paragraphStyle,
                                     foregroundColor: textColor)
        }
        
        do {
            thematicBreak = ThematicBreakStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular),
                                               foregroundColor: textColor)
        }
        
        do {
            tableHead = TableHeadStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular))
        }
        
        do {
            tableCell = TableCellStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            blockQuote = BlockQuoteStyle(font: Font.monospacedSystemFont(ofSize: 16, weight: .regular).italic(),
                                         paragraphStyle: paragraphStyle,
                                         foregroundColor: textColor,
                                         backgroundColor: .clear)
        }
        
        do {
            softBreak = SoftBreakStyle(lineBreakHeight: 6)
        }
    }
    
}

struct DocumentStyle {
    var paragraphStyle: NSParagraphStyle
}

struct ParagraphStyle {
    var lineBreakHeight: CGFloat
}

struct TextStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
    
}

struct HeadingStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
    var lineBreakHeight: CGFloat
}

struct LinkStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
}

struct StrongStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
}

struct InlineCodeStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
    var backgroundColor: Color?
}

struct CodeBlockStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
    var backgroundColor: Color?
}

struct ListItemStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
}

struct ThematicBreakStyle {
    var font: Font
    var foregroundColor: Color?
}

struct TableHeadStyle {
    var font: Font
}

struct TableCellStyle {
    var font: Font
}

struct BlockQuoteStyle {
    var font: Font
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: Color?
    var backgroundColor: Color?
}

struct SoftBreakStyle {
    var lineBreakHeight: CGFloat
}
