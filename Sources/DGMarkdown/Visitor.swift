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
    
    let style: Style
    
}

extension Visitor: MarkupVisitor {
    
    typealias Result = AttributedString
    
    mutating func defaultVisit(_ markup: Markup) -> AttributedString {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
    }

    mutating func visitDocument(_ document: Document) -> AttributedString {
        var string = AttributedString("\n")
        string += defaultVisit(document)
        return string
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> AttributedString {
        var string = defaultVisit(paragraph)
        string.appendBlankLine(withLineHeight: style.paragraph.lineBreakHeight)
        return string
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> AttributedString {
        var string = AttributedString()
        string.appendBlankLine(withLineHeight: style.softBreak.lineBreakHeight)
        string.inlinePresentationIntent = .softBreak
        return string
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> AttributedString {
        var string = AttributedString("\n")
        string.inlinePresentationIntent = .lineBreak
        return string
    }
    
    func visitText(_ text: Text) -> AttributedString {
        var string = AttributedString(text.plainText)
        string.font = style.text.font
        string.paragraphStyle = style.text.paragraphStyle
        string.foregroundColor = style.text.foregroundColor
        return string
    }
    
    func visitInlineCode(_ inlineCode: InlineCode) -> AttributedString {
        var string = AttributedString(inlineCode.code)
        string.font = style.inlineCode.font
        string.paragraphStyle = style.inlineCode.paragraphStyle
        string.foregroundColor = style.inlineCode.foregroundColor
        string.backgroundColor = style.inlineCode.backgroundColor
        string.inlinePresentationIntent = .code
        return string
    }
    
    func visitCodeBlock(_ codeBlock: CodeBlock) -> AttributedString {
        let identifier: DGSyntaxHighlighter.Identifier
        if let language = codeBlock.language {
            identifier = .init(rawValue: language) ?? .plain
        } else {
            identifier = .plain
        }

        var heading = AttributedString("\u{00a0}\n")
        heading.backgroundColor = style.codeBlock.backgroundColor
        heading.paragraphStyle = style.codeBlock.paragraphStyle
        heading.font = style.codeBlock.font

        var tailing = AttributedString()
        tailing.append(AttributedString.blankLine(withLineHeight: 0))
        tailing.append(AttributedString("\n"))

        tailing.backgroundColor = style.codeBlock.backgroundColor
        tailing.paragraphStyle = style.codeBlock.paragraphStyle
        tailing.font = style.codeBlock.font

        var string = AttributedString()
        string += DGSyntaxHighlighter.highlighted(string: codeBlock.code, identifier: identifier)

        guard let paragraphStyle = style.codeBlock.paragraphStyle.mutableCopy() as? NSMutableParagraphStyle else { return string }
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = style.codeBlock.indent
        paragraphStyle.headIndent = style.codeBlock.indent
        paragraphStyle.tailIndent = -style.codeBlock.indent
        paragraphStyle.lineSpacing = style.codeBlock.lineSpacing

        string.paragraphStyle = paragraphStyle
        string.backgroundColor = style.codeBlock.backgroundColor
        string.baselineOffset = -style.codeBlock.lineSpacing

        return heading + string + tailing
    }
    
    mutating func visitHeading(_ heading: Heading) -> AttributedString {
        let headingStyle: HeadingStyle
        switch heading.level {
        case 1: headingStyle = style.h1
        case 2: headingStyle = style.h2
        case 3: headingStyle = style.h3
        default: headingStyle = style.h4
        }
        var string = AttributedString(heading.plainText)
        string.font = headingStyle.font
        string.paragraphStyle = headingStyle.paragraphStyle
        string.foregroundColor = headingStyle.foregroundColor
        string.appendLineBreak()
        return string
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> AttributedString {
        var string = defaultVisit(emphasis)
        string.inlinePresentationIntent = .emphasized
        return string
    }
    
    mutating func visitStrong(_ strong: Strong) -> AttributedString {
        var string = defaultVisit(strong)
        string.font = style.strong.font
        return string
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> AttributedString {
        var string = defaultVisit(strikethrough)
        string.inlinePresentationIntent = .strikethrough
        string.strikethroughStyle = .single
        return string
    }
    
    mutating func visitLink(_ link: Link) -> AttributedString {
        var string = defaultVisit(link)
        if let destination = link.destination, let link = URL(string: destination) {
            string.link = link
        }
        return string
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> AttributedString {
        var depth = 0
        var parent = listItem.parent
        while parent != nil {
            if parent is ListItem {
                depth += 1
            }
            parent = parent?.parent
        }
        
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
            switch depth {
            case 0: prefix = "•"
            case 1: prefix = "•"
            case 2: prefix = "⁃"
            default: prefix = "⁃"
            }
        }
        
        let spacing = String(repeating: " ", count: 2*depth)
        var string = AttributedString("\(spacing)\(prefix) ")
        string += defaultVisit(listItem)
        string.font = style.listItem.font
        string.paragraphStyle = style.listItem.paragraphStyle
        string.foregroundColor = style.listItem.foregroundColor
        return string
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> AttributedString {
        var string = AttributedString("\n\u{00a0}\n")
        string.strikethroughStyle = .single
        string.strikethroughColor = style.thematicBreak.foregroundColor
        string.font = style.thematicBreak.font
        return string
    }
    
    mutating func visitTable(_ table: Table) -> AttributedString {
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
        """.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return AttributedString("") }

        guard let html = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return AttributedString("")
        }

        var string = AttributedString(html)
        string.font = style.table.font
        string.foregroundColor = style.table.foregroundColor
        string.appendBlankLine(withLineHeight: style.table.paragraphSpacing)
        return string
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> AttributedString {
        var heading = AttributedString("❝ ")
        heading.font = Font.systemFont(ofSize: 32)
        heading.foregroundColor = style.blockQuote.foregroundColor
        heading.backgroundColor = style.blockQuote.backgroundColor

        var body = defaultVisit(blockQuote)
        body.font = style.blockQuote.font
        body.foregroundColor = style.blockQuote.foregroundColor
        body.backgroundColor = style.blockQuote.backgroundColor

        let string = heading + body

        guard let paragraphStyle = style.blockQuote.paragraphStyle.mutableCopy() as? NSMutableParagraphStyle else { return string }

        let attributedString = NSMutableAttributedString(string)

        var depth = 0
        var parent = blockQuote.parent
        while parent != nil {
            if parent is BlockQuote {
                depth += 1
            }
            parent = parent?.parent
        }

        let indent = CGFloat(depth + 1)*20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indent, options: [:])]
        paragraphStyle.firstLineHeadIndent = indent
        paragraphStyle.headIndent = indent

        var renderedRanges = [NSRange]()
        attributedString.enumerateAttribute(.expansion, in: NSRange(0..<attributedString.length)) { value, range, stop in
            if value != nil {
                renderedRanges.append(range)
            }
        }

        var unrenderedRanges: [NSRange] = [NSMakeRange(0, attributedString.length)]
        repeat {
            var matched = false

            for renderedRange in renderedRanges {
                for (index, unrenderedRange) in unrenderedRanges.enumerated() {
                    guard renderedRange.intersection(unrenderedRange) != nil else {
                        continue
                    }

                    unrenderedRanges.remove(at: index)
                    unrenderedRanges.append(NSRange(location: min(unrenderedRange.lowerBound, renderedRange.lowerBound),
                                                   length: abs(unrenderedRange.lowerBound - renderedRange.lowerBound)))
                    unrenderedRanges.append(NSRange(location: min(unrenderedRange.upperBound, renderedRange.upperBound),
                                                   length: abs(unrenderedRange.upperBound - renderedRange.upperBound)))

                    matched = true
                    break
                }
            }

            if !matched {
                break
            }
        } while unrenderedRanges.count > 0

        for unrenderedRange in unrenderedRanges {
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: unrenderedRange)
            attributedString.addAttribute(.expansion, value: CGFloat.leastNormalMagnitude, range: unrenderedRange)
        }

        return AttributedString(attributedString)
    }
    
    mutating func visitImage(_ image: Image) -> AttributedString {
        guard let source = image.source else {
            return AttributedString(image.plainText)
        }
        
        let data = Data("""
        <img src="\(source)">
        """.utf8)
            
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return AttributedString(image.plainText)
        }
        
        return AttributedString(attributedString)
    }
    
    mutating func visitHTMLBlock(_ html: HTMLBlock) -> AttributedString {
        let data = Data("""
        \(html.rawHTML)
        """.utf8)
            
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return defaultVisit(html)
        }
        
        return AttributedString(attributedString) + "\n"
    }

}

