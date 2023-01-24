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
public typealias Font = NSFont
public typealias Color = NSColor
#else
import UIKit
public typealias Font = UIFont
public typealias Color = UIColor
#endif

public struct DGMarkdownStyleSheet {
    
    #if canImport(Cocoa)
    private let textColor = Color.textColor
    private let secondaryColor = Color.secondaryLabelColor
    #else
    private let textColor = Color.label
    private let secondaryColor = Color.secondaryLabel
    #endif
    
    public var document: DocumentStyle
    public var paragraph: ParagraphStyle
    
    public var text: TextStyle
    public var h1: HeadingStyle
    public var h2: HeadingStyle
    public var h3: HeadingStyle
    public var h4: HeadingStyle
    public var link: LinkStyle
    public var strong: StrongStyle
    public var italic: ItalicStyle
    public var strikethrough: StrikethroughStyle
    public var inlineCode: InlineCodeStyle
    public var codeBlock: CodeBlockStyle
    public var listItem: ListItemStyle
    public var thematicBreak: ThematicBreakStyle
    public var table: TableStyle
    public var blockQuote: BlockQuoteStyle
    public var softBreak: SoftBreakStyle
    
    public init() {
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            document = DocumentStyle(paragraphStyle: paragraphStyle)
        }
        
        do {
            paragraph = ParagraphStyle(lineBreakHeight: 20)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            text = TextStyle(font: Font.systemFont(ofSize: 16),
                             paragraphStyle: paragraphStyle,
                             foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 24
            h1 = HeadingStyle(font: Font.systemFont(ofSize: 32, weight: .heavy),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 14)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 18
            h2 = HeadingStyle(font: Font.systemFont(ofSize: 28, weight: .bold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 10)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 12
            h3 = HeadingStyle(font: Font.systemFont(ofSize: 24, weight: .semibold),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 8)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 8
            h4 = HeadingStyle(font: Font.systemFont(ofSize: 20, weight: .medium),
                              paragraphStyle: paragraphStyle,
                              foregroundColor: textColor,
                              lineBreakHeight: 4)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            link = LinkStyle(font: Font.systemFont(ofSize: 16, weight: .light),
                             paragraphStyle: paragraphStyle,
                             foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            strong = StrongStyle(font: Font.systemFont(ofSize: 16).withBold(),
                                 paragraphStyle: paragraphStyle,
                                 foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            italic = ItalicStyle(font: Font.systemFont(ofSize: 16).withItalic(),
                                 paragraphStyle: paragraphStyle,
                                 foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            strikethrough = StrikethroughStyle(font: Font.systemFont(ofSize: 16),
                                               paragraphStyle: paragraphStyle,
                                               foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            inlineCode = InlineCodeStyle(font: Font.systemFont(ofSize: 16),
                                         paragraphStyle: paragraphStyle,
                                         foregroundColor: Color.color(withHex: 0xFFFFFF, alpha: 0.85),
                                         backgroundColor: Color.color(withHex: 0x161616))
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            codeBlock = CodeBlockStyle(font: Font.systemFont(ofSize: 16),
                                       paragraphStyle: paragraphStyle,
                                       foregroundColor: Color.color(withHex: 0xFFFFFF, alpha: 0.85),
                                       backgroundColor: Color.color(withHex: 0x161616),
                                       indent: 28,
                                       lineSpacing: 4)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            listItem = ListItemStyle(font: Font.systemFont(ofSize: 16),
                                     paragraphStyle: paragraphStyle,
                                     foregroundColor: textColor)
        }
        
        do {
            thematicBreak = ThematicBreakStyle(font: Font.systemFont(ofSize: 16),
                                               foregroundColor: textColor)
        }
        
        do {
            table = TableStyle(font: Font.systemFont(ofSize: 16),
                               foregroundColor: textColor)
        }
        
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            blockQuote = BlockQuoteStyle(font: Font.systemFont(ofSize: 16, weight: .regular).withItalic(),
                                         paragraphStyle: paragraphStyle,
                                         foregroundColor: secondaryColor,
                                         backgroundColor: .clear)
        }
        
        do {
            softBreak = SoftBreakStyle(lineBreakHeight: 6)
        }
    }
    
}

public struct DocumentStyle {
    public var paragraphStyle: NSParagraphStyle
}

public struct ParagraphStyle {
    public var lineBreakHeight: CGFloat
}

public struct TextStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
    
}

public struct HeadingStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
    public var lineBreakHeight: CGFloat
}

public struct LinkStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
}

public struct StrongStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
}

public struct ItalicStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
}

public struct StrikethroughStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
}

public struct InlineCodeStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
    public var backgroundColor: Color?
}

public struct CodeBlockStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
    public var backgroundColor: Color?
    public var indent: CGFloat
    public var lineSpacing: CGFloat
}

public struct ListItemStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
}

public struct ThematicBreakStyle {
    public var font: Font?
    public var foregroundColor: Color?
}

public struct TableStyle {
    public var font: Font?
    public var foregroundColor: Color?
}

public struct BlockQuoteStyle {
    public var font: Font?
    public var paragraphStyle: NSParagraphStyle
    public var foregroundColor: Color?
    public var backgroundColor: Color?
}

public struct SoftBreakStyle {
    public var lineBreakHeight: CGFloat
}
