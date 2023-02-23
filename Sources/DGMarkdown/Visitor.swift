//
//  Visitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Markdown
import DGSyntaxHighlighter

#if canImport(Cocoa)
import AppKit
#else
import UIKit
#endif

struct Visitor {
    
    let styleSheet: DGMarkdownStyleSheet

    weak var delegate: DGMarkdownDelegate?

    init(delegate: DGMarkdownDelegate?,
         styleSheet: DGMarkdownStyleSheet = DGMarkdownStyleSheet()) {
        self.styleSheet = styleSheet
        self.delegate = delegate
    }
    
    private var indentOffset: CGFloat = 0
    private var indentLevel = 0
    
}

extension Visitor: MarkupVisitor {
    
    typealias Result = NSMutableAttributedString
    
    mutating func defaultVisit(_ markup: Markup) -> Result {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0 += $1 }
    }

    mutating func visitDocument(_ document: Document) -> Result {
        let string = NSMutableAttributedString()
        string.appendLineBreak()
        string += defaultVisit(document)
        return string
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> Result {
        let string = NSMutableAttributedString()
        string += defaultVisit(paragraph)
        string.appendLineBreak()
        string.appendBlankLine(withLineHeight: styleSheet.paragraph.lineBreakHeight)
        return string
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Result {
        let string = NSMutableAttributedString()
        string.appendLineBreak()
        string.appendBlankLine(withLineHeight: styleSheet.softBreak.lineBreakHeight)
        return string
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> Result {
        let string = NSMutableAttributedString()
        string.appendLineBreak()
        return string
    }
    
    mutating func visitText(_ text: Text) -> Result {
        let string = NSMutableAttributedString()
        string += text.plainText
        string.mergeAttributes([.font: styleSheet.text.font as Any,
                                .foregroundColor: styleSheet.text.foregroundColor as Any,
                                .paragraphStyle: styleSheet.text.paragraphStyle])
        return string
    }
    
    mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        let string = NSMutableAttributedString()
        string += " \(inlineCode.code) "
        string.mergeAttributes([.font: styleSheet.inlineCode.font as Any,
                                .foregroundColor: styleSheet.inlineCode.foregroundColor as Any,
                                .backgroundColor: styleSheet.inlineCode.backgroundColor as Any,
                                .paragraphStyle: styleSheet.inlineCode.paragraphStyle])
        return string
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        let identifier: DGSyntaxHighlighter.Identifier
        if let language = codeBlock.language {
            identifier = .init(rawValue: language) ?? .plain
        } else {
            identifier = .plain
        }
        
        let heading = NSMutableAttributedString()
        heading.appendLineBreak()
        heading.setAttributes([.font: styleSheet.codeBlock.font as Any,
                               .backgroundColor: styleSheet.codeBlock.backgroundColor as Any,
                               .paragraphStyle: styleSheet.codeBlock.paragraphStyle], range: NSRange(0..<heading.length))

        let tailing = NSMutableAttributedString()
        tailing.appendBlankLine(withLineHeight: 0)
        tailing.setAttributes([.font: styleSheet.codeBlock.font as Any,
                               .backgroundColor: styleSheet.codeBlock.backgroundColor as Any,
                               .paragraphStyle: styleSheet.codeBlock.paragraphStyle], range: NSRange(0..<heading.length))

        let code = NSMutableAttributedString()
        code += DGSyntaxHighlighter(identifier: identifier, styleSheet: { () -> DGSyntaxHighlighterStyleSheet in
            var styleSheet = DGSyntaxHighlighterStyleSheet()
            styleSheet.text.font = self.styleSheet.codeBlock.font
            styleSheet.text.foregroundColor = self.styleSheet.codeBlock.foregroundColor
            styleSheet.keyword.font = self.styleSheet.codeBlock.font
            styleSheet.string.font = self.styleSheet.codeBlock.font
            styleSheet.comment.font = self.styleSheet.codeBlock.font
            styleSheet.emphasis.font = self.styleSheet.codeBlock.font
            styleSheet.link.font = self.styleSheet.codeBlock.font
            return styleSheet
        }()).highlighted(string: codeBlock.code, options: .all)

        guard let paragraphStyle = styleSheet.codeBlock.paragraphStyle.mutableCopy() as? NSMutableParagraphStyle else { return defaultVisit(codeBlock) }
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = styleSheet.codeBlock.indent
        paragraphStyle.headIndent = styleSheet.codeBlock.indent
        paragraphStyle.tailIndent = -styleSheet.codeBlock.indent
        paragraphStyle.lineSpacing = styleSheet.codeBlock.lineSpacing
        code.addAttributes([.paragraphStyle: paragraphStyle as Any,
                              .backgroundColor: styleSheet.codeBlock.backgroundColor as Any,
                              .baselineOffset: -styleSheet.codeBlock.lineSpacing], range: NSRange(0..<code.length))
        
        let string = NSMutableAttributedString()
        string += heading
        string += code
        string += tailing
        string.appendLineBreak()
        return string
    }
    
    mutating func visitHeading(_ heading: Heading) -> Result {
        let headingStyle: HeadingStyle
        switch heading.level {
        case 1: headingStyle = styleSheet.h1
        case 2: headingStyle = styleSheet.h2
        case 3: headingStyle = styleSheet.h3
        default: headingStyle = styleSheet.h4
        }
        let string = NSMutableAttributedString()
        string += defaultVisit(heading)
        string.mergeAttributes([.font: headingStyle.font as Any,
                                .foregroundColor: headingStyle.foregroundColor as Any,
                                .paragraphStyle: headingStyle.paragraphStyle])
        string.appendLineBreak()
        return string
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> Result {
        let string = NSMutableAttributedString()
        string += defaultVisit(emphasis)
        string.mergeAttributes([.font: styleSheet.italic.font as Any,
                                .foregroundColor: styleSheet.italic.foregroundColor as Any])
        return string
    }
    
    mutating func visitStrong(_ strong: Strong) -> Result {
        let string = NSMutableAttributedString()
        string += defaultVisit(strong)
        string.mergeAttributes([.font: styleSheet.strong.font as Any,
                                .foregroundColor: styleSheet.strong.foregroundColor as Any])
        return string
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Result {
        let string = NSMutableAttributedString()
        string += defaultVisit(strikethrough)
        string.mergeAttributes([.font: styleSheet.strikethrough.font as Any,
                                .foregroundColor: styleSheet.strikethrough.foregroundColor as Any,
                                .strikethroughStyle: 1])
        return string
    }
    
    mutating func visitLink(_ link: Link) -> Result {
        let string = NSMutableAttributedString()
        string += defaultVisit(link)
        if let destination = link.destination, let link = URL(string: destination) {
            string.mergeAttributes([.link: link as Any])
        }
        string.mergeAttributes([.font: styleSheet.link.font as Any])

        return string
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> Result {
        indentOffset += Indent.orderedList.offset
        indentLevel += 1
        
        let string = defaultVisit(orderedList)
        string.indent(for: indentOffset)
        
        indentOffset -= Indent.orderedList.offset
        indentLevel -= 1
        
        return string
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Result {
        indentOffset += Indent.unorderedList.offset
        indentLevel += 1
        
        let string = defaultVisit(unorderedList)
        string.indent(for: indentOffset)
        
        indentOffset -= Indent.unorderedList.offset
        indentLevel -= 1
        
        return string
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> Result {
        let prefix: String
        if let checkbox = listItem.checkbox {
            if checkbox == .checked {
                prefix = "✅"
            } else {
                prefix = "⬜"
            }
        } else if listItem.parent is OrderedList {
            prefix = "\(listItem.indexInParent + 1)."
        } else {
            switch indentLevel {
            case 1: prefix = "•"
            case 2: prefix = "•"
            case 3: prefix = "⁃"
            default: prefix = "⁃"
            }
        }
        
        let string = NSMutableAttributedString()
        string += prefix
        string += " "
        string += defaultVisit(listItem)
        string.mergeAttributes([.font: styleSheet.listItem.font as Any,
                                .foregroundColor: styleSheet.listItem.foregroundColor as Any,
                                .paragraphStyle: styleSheet.listItem.paragraphStyle])
        return string
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        let string = NSMutableAttributedString()
        string += "\u{00A0}\n"
        string.setAttributes([.font: styleSheet.strikethrough.font as Any,
                              .strikethroughColor: styleSheet.strikethrough.foregroundColor as Any,
                              .strikethroughStyle: 1], range: NSRange(0..<string.length))
        return string
    }
    
    mutating func visitTable(_ table: Table) -> Result {
        guard let data = """
        <html>
        <head>
        <style>
        table {
          border-collapse: collapse;
          width: 100%;
          text-align: center;
        }
        td, th {
          border: 1px solid #999999;
          padding: 10px;
        }
        </style>
        </head>
        <body>
        <table>
        \({ () -> String in
        var html = ""
        for head in table.head.cells.map({ $0.plainText }) {
            html += "<th>\(head)</th>"
        }
        html += "</tr>"

        for row in table.body.rows {
            html += "<tr>"
            for cell in row.cells.map({ $0.plainText }) {
                html += "<td>\(cell)</td>"
            }
            html += "</tr>"
        }
        return html
        }())
        </table>
        </body>
        </html>
        """.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return NSMutableAttributedString() }

        guard let html = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return NSMutableAttributedString()
        }

        let string = NSMutableAttributedString()
        string += html
        string.mergeAttributes([.font: styleSheet.table.font as Any,
                                .foregroundColor: styleSheet.table.foregroundColor as Any])
        string.appendLineBreak()
        return string
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        indentOffset += Indent.blockQuote.offset
        indentLevel += 1

        let string = defaultVisit(blockQuote)
        string.mergeAttributes([.font: styleSheet.blockQuote.font as Any,
                                .foregroundColor: styleSheet.blockQuote.foregroundColor as Any,
                                .backgroundColor: styleSheet.blockQuote.backgroundColor as Any,
                                .paragraphStyle: styleSheet.blockQuote.paragraphStyle])
        string.indent(for: indentOffset)
        
        indentOffset -= Indent.blockQuote.offset
        indentLevel -= 1
        
        return string
    }
    
    mutating func visitImage(_ image: Image) -> Result {
        guard let source = image.source,
              let url = URL(string: source) else {
            return defaultVisit(image)
        }

        if let processImage = delegate?.processImage {
            let attachment = NSTextAttachment()
            processImage(url, image.title, attachment)
            let string = NSMutableAttributedString(attachment: attachment)
            string.mergeAttributes([.foregroundColor: styleSheet.text.foregroundColor as Any])
            return string
        } else {
            guard let data = """
            <html>
            <body>
            <div>
            <img src="\(url)">
            </div>
            </body>
            </html>
            """.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
                return defaultVisit(image)
            }

            var options = [NSAttributedString.DocumentReadingOptionKey: Any]()
            options[.documentType] = NSAttributedString.DocumentType.html

            #if canImport(Cocoa)
            options[.baseURL] = url
            #endif

            guard let string = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
                return defaultVisit(image)
            }

            string.appendLineBreak()
            return string
        }
    }
    
    mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
        guard let data = """
        <html>
        <body>
        \(html.rawHTML)
        </body>
        </html>
        """.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return defaultVisit(html)
        }

        var options = [NSAttributedString.DocumentReadingOptionKey: Any]()
        options[.documentType] = NSAttributedString.DocumentType.html

        guard let string = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
            return defaultVisit(html)
        }

        string.mergeAttributes([.foregroundColor: styleSheet.text.foregroundColor as Any])
        string.appendLineBreak()
        return string
    }

}

enum Indent {
    case orderedList, unorderedList, blockQuote
    var offset: CGFloat {
        switch self {
            case .orderedList:
                return 15
            case .unorderedList:
                return 15
            case .blockQuote:
                return 20
        }
    }
}
