//
//  Style.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Cocoa
import Markdown
import DGExtension

public struct Style {
    
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
            text = TextStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                                 paragraphStyle: paragraphStyle,
                                 foregroundColor: .textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h1 = HeadingStyle(font: NSFont.monospacedSystemFont(ofSize: 32, weight: .heavy),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: .textColor,
                              lineBreakHeight: 14)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h2 = HeadingStyle(font: NSFont.monospacedSystemFont(ofSize: 28, weight: .bold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: .textColor,
                              lineBreakHeight: 10)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h3 = HeadingStyle(font: NSFont.monospacedSystemFont(ofSize: 24, weight: .semibold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: .textColor,
                              lineBreakHeight: 8)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            h4 = HeadingStyle(font: NSFont.monospacedSystemFont(ofSize: 20, weight: .medium),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: .textColor,
                              lineBreakHeight: 4)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            link = LinkStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .light),
                             paragraphStyle: paragraphStyle,
                             foregroundColor: .textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            strong = StrongStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .bold),
                                 paragraphStyle: paragraphStyle,
                                 foregroundColor: .textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            inlineCode = InlineCodeStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                                         paragraphStyle: paragraphStyle,
                                         foregroundColor: .textColor,
                                         backgroundColor: .lightGray)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            codeBlock = CodeBlockStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                                       paragraphStyle: paragraphStyle,
                                       foregroundColor: NSColor.color(withHex: 0xFFFFFF, alpha: 0.85),
                                       backgroundColor: NSColor.color(withHex: 0x161616))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            listItem = ListItemStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                                      paragraphStyle: paragraphStyle,
                                      foregroundColor: .textColor)
        }
        
        do {
            thematicBreak = ThematicBreakStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                                               foregroundColor: .textColor)
        }
        
        do {
            tableHead = TableHeadStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular))
        }
        
        do {
            tableCell = TableCellStyle(font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            blockQuote = BlockQuoteStyle(font: NSFontManager.shared.convert(NSFont.monospacedSystemFont(ofSize: 16, weight: .regular), toHaveTrait: .italicFontMask),
                                         paragraphStyle: paragraphStyle,
                                         foregroundColor: .textColor,
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
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor
    
}

struct HeadingStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor
    var lineBreakHeight: CGFloat
}

struct LinkStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor
}

struct StrongStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor
}

struct InlineCodeStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor?
    var backgroundColor: NSColor?
}

struct CodeBlockStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor?
    var backgroundColor: NSColor?
}

struct ListItemStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor?
}

struct ThematicBreakStyle {
    var font: NSFont
    var foregroundColor: NSColor?
}

struct TableHeadStyle {
    var font: NSFont
}

struct TableCellStyle {
    var font: NSFont
}

struct BlockQuoteStyle {
    var font: NSFont
    var paragraphStyle: NSParagraphStyle
    var foregroundColor: NSColor?
    var backgroundColor: NSColor?
}

struct SoftBreakStyle {
    var lineBreakHeight: CGFloat
}
