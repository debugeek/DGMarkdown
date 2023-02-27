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
        return NSMutableAttributedString()
            .appendLineBreak()
            .append(defaultVisit(document))
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> Result {
        return NSMutableAttributedString()
            .append(defaultVisit(paragraph))
            .appendLineBreak()
            .appendBlankLine(withLineHeight: styleSheet.paragraph.lineBreakHeight)
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Result {
        return NSMutableAttributedString()
            .appendLineBreak()
            .appendBlankLine(withLineHeight: styleSheet.softBreak.lineBreakHeight)
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> Result {
        return NSMutableAttributedString()
            .appendLineBreak()
    }
    
    mutating func visitText(_ text: Text) -> Result {
        return NSMutableAttributedString()
            .append(text.plainText)
            .merge(font: styleSheet.text.font)
            .merge(foregroundColor: styleSheet.text.foregroundColor)
            .merge(paragraphStyle: styleSheet.text.paragraphStyle)
    }
    
    mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        return NSMutableAttributedString()
            .append(" \(inlineCode.code) ")
            .merge(font: styleSheet.inlineCode.font)
            .merge(foregroundColor: styleSheet.inlineCode.foregroundColor)
            .merge(backgroundColor: styleSheet.inlineCode.backgroundColor)
            .merge(paragraphStyle: styleSheet.inlineCode.paragraphStyle)
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
        
        return NSMutableAttributedString()
            .append(heading)
            .append(code)
            .append(tailing)
            .appendLineBreak()
    }
    
    mutating func visitHeading(_ heading: Heading) -> Result {
        let headingStyle: HeadingStyle
        switch heading.level {
        case 1: headingStyle = styleSheet.h1
        case 2: headingStyle = styleSheet.h2
        case 3: headingStyle = styleSheet.h3
        default: headingStyle = styleSheet.h4
        }
        
        return NSMutableAttributedString()
            .append(defaultVisit(heading))
            .merge(font: headingStyle.font)
            .merge(foregroundColor: headingStyle.foregroundColor)
            .merge(paragraphStyle: headingStyle.paragraphStyle)
            .appendLineBreak()
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> Result {
        return NSMutableAttributedString()
            .append(defaultVisit(emphasis))
            .merge(font: styleSheet.italic.font)
            .merge(foregroundColor: styleSheet.italic.foregroundColor)
    }
    
    mutating func visitStrong(_ strong: Strong) -> Result {
        return NSMutableAttributedString()
            .append(defaultVisit(strong))
            .merge(font: styleSheet.strong.font)
            .merge(foregroundColor: styleSheet.strong.foregroundColor)
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Result {
        return NSMutableAttributedString()
            .append(defaultVisit(strikethrough))
            .merge(font: styleSheet.strikethrough.font)
            .merge(foregroundColor: styleSheet.strikethrough.foregroundColor)
            .merge(attrs: [.strikethroughStyle: 1])
    }
    
    mutating func visitLink(_ link: Link) -> Result {
        let string = NSMutableAttributedString()
            .append(defaultVisit(link))
            .merge(font: styleSheet.link.font)
        
        if let destination = link.destination, let link = URL(string: destination) {
            string.merge(attrs: [.link: link])
        }
        
        return string
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> Result {
        indentOffset += Indent.orderedList.offset
        indentLevel += 1
        defer {
            indentOffset -= Indent.orderedList.offset
            indentLevel -= 1
        }
        
        return NSMutableAttributedString()
            .append(defaultVisit(orderedList))
            .indent(for: indentOffset)
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Result {
        indentOffset += Indent.unorderedList.offset
        indentLevel += 1
        defer {
            indentOffset -= Indent.unorderedList.offset
            indentLevel -= 1
        }
        
        return NSMutableAttributedString()
            .append(defaultVisit(unorderedList))
            .indent(for: indentOffset)
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
        
        return NSMutableAttributedString()
            .append(prefix + " ")
            .append(defaultVisit(listItem))
            .merge(font: styleSheet.listItem.font)
            .merge(foregroundColor: styleSheet.listItem.foregroundColor)
            .merge(paragraphStyle: styleSheet.listItem.paragraphStyle)
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        return NSMutableAttributedString()
            .append("\u{00A0}\n")
            .merge(font: styleSheet.strikethrough.font)
            .merge(attrs: [.strikethroughColor: styleSheet.strikethrough.foregroundColor as Any,
                           .strikethroughStyle: 1])
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
        
        guard let html = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return NSMutableAttributedString()
        }
        
        return NSMutableAttributedString()
            .append(html)
            .merge(font: styleSheet.table.font)
            .merge(foregroundColor: styleSheet.table.foregroundColor)
            .appendLineBreak()
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        indentOffset += Indent.blockQuote.offset
        indentLevel += 1
        defer {
            indentOffset -= Indent.blockQuote.offset
            indentLevel -= 1
        }

        return NSMutableAttributedString()
            .append(defaultVisit(blockQuote))
            .merge(font: styleSheet.blockQuote.font)
            .merge(foregroundColor: styleSheet.blockQuote.foregroundColor)
            .merge(backgroundColor: styleSheet.blockQuote.backgroundColor)
            .merge(paragraphStyle: styleSheet.blockQuote.paragraphStyle)
            .indent(for: indentOffset)
    }
    
    mutating func visitImage(_ image: Image) -> Result {
        guard let source = image.source,
              let url = URL(string: source) else {
            return defaultVisit(image)
        }

        if let processImage = delegate?.processImage {
            let attachment = NSTextAttachment()
            processImage(url, image.title, attachment)
            return NSMutableAttributedString(attachment: attachment)
                .merge(attrs: [.foregroundColor: styleSheet.text.foregroundColor as Any])
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

            guard let html = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
                return defaultVisit(image)
            }

            return NSMutableAttributedString()
                .append(html)
                .appendLineBreak()
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

        guard let html = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
            return defaultVisit(html)
        }

        return NSMutableAttributedString()
            .append(html)
            .merge(foregroundColor: styleSheet.text.foregroundColor)
            .appendLineBreak()
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

extension NSMutableAttributedString {
    
    @discardableResult
    fileprivate func merge(font: Font?, range: NSRange? = nil) -> Self {
        return merge(attrs: [.font: font as Any], range: range) { key, oldValue, newValue in
            guard let newValue = newValue as? Font, let oldValue = oldValue as? Font else { return nil }
            
            var resolvedValue = newValue.pointSize > oldValue.pointSize ? newValue : oldValue
            if newValue.isBold() || oldValue.isBold() {
                resolvedValue = resolvedValue.withBold()
            }
            if newValue.isItalic() || oldValue.isItalic() {
                resolvedValue = resolvedValue.withItalic()
            }
            return resolvedValue
        }
    }
    
    @discardableResult
    fileprivate func merge(foregroundColor: Color?, range: NSRange? = nil) -> Self  {
        return merge(attrs: [.foregroundColor: foregroundColor as Any], range: range) { key, oldValue, newValue in
            return newValue
        }
    }
    
    @discardableResult
    fileprivate func merge(backgroundColor: Color?, range: NSRange? = nil) -> Self  {
        return merge(attrs: [.backgroundColor: backgroundColor as Any], range: range) { key, oldValue, newValue in
            return newValue
        }
    }
    
    @discardableResult
    fileprivate func merge(paragraphStyle: NSParagraphStyle?, range: NSRange? = nil) -> Self  {
        return merge(attrs: [.paragraphStyle: paragraphStyle as Any], range: range) { key, oldValue, newValue in
            guard let newValue = newValue as? NSParagraphStyle, let oldValue = oldValue as? NSParagraphStyle else { return nil }
            
            let resolvedValue = NSMutableParagraphStyle()
            resolvedValue.headIndent = max(newValue.headIndent, oldValue.headIndent)
            resolvedValue.firstLineHeadIndent = max(newValue.firstLineHeadIndent, oldValue.firstLineHeadIndent)
            resolvedValue.paragraphSpacing = max(newValue.paragraphSpacing, oldValue.paragraphSpacing)
            resolvedValue.lineSpacing = max(newValue.lineSpacing, oldValue.lineSpacing)
            resolvedValue.maximumLineHeight = max(newValue.maximumLineHeight, oldValue.maximumLineHeight)
            resolvedValue.maximumLineHeight = max(newValue.maximumLineHeight, oldValue.maximumLineHeight)
            return resolvedValue
        }
    }
    
    @discardableResult
    fileprivate func indent(for offset: CGFloat) -> Self  {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = offset
        paragraphStyle.firstLineHeadIndent = offset
        return merge(paragraphStyle: paragraphStyle)
    }
    
}
