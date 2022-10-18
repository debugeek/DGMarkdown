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
        var string = defaultVisit(document)
        string.paragraphStyle = style.document.paragraphStyle
        return .blankLine(withHeight: 20) + "\n" + string + "\n" + .blankLine(withHeight: 20)
    }
    
    mutating func visitParagraph(_ paragraph: Paragraph) -> AttributedString {
        return defaultVisit(paragraph).appendingBlankLine(withHeight: style.paragraph.lineBreakHeight)
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> AttributedString {
        var string = AttributedString.blankLine(withHeight: style.softBreak.lineBreakHeight)
        string.inlinePresentationIntent = .softBreak
        return "\n" + string + "\n"
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
        
        var string = DGSyntaxHighlighter.highlighted(string: codeBlock.code, identifier: identifier)
        string.paragraphStyle = style.codeBlock.paragraphStyle
        string.backgroundColor = style.codeBlock.backgroundColor
        return string + "\n"
    }
    
    mutating func visitHeading(_ heading: Heading) -> AttributedString {
        let headingStyle: HeadingStyle
        switch heading.level {
        case 1: headingStyle = style.h1
        case 2: headingStyle = style.h2
        case 3: headingStyle = style.h3
        default: headingStyle = style.h4
        }
        var string = defaultVisit(heading)
        string.font = headingStyle.font
        string.paragraphStyle = headingStyle.paragraphStyle
        string.foregroundColor = headingStyle.foregroundColor
        return string.appendingBlankLine(withHeight: headingStyle.lineBreakHeight)
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
        return "\n" + defaultVisit(table) + "\n"
    }
    
    mutating func visitTableHead(_ tableHead: Table.Head) -> AttributedString {
        var string = defaultVisit(tableHead)
        string.font = style.tableHead.font
        return string
    }
    
    mutating func visitTableCell(_ tableCell: Table.Cell) -> AttributedString {
        var parent = tableCell.parent
        while parent != nil {
            if parent is Table {
                break
            }
            parent = parent?.parent
        }
        
        var maxCharactersPerColumn = [Int: Int]()
        if let table = parent as? Table {
            for (column, cell) in table.head.cells.enumerated() {
                maxCharactersPerColumn[column] = max(cell.plainText.count, maxCharactersPerColumn[column, default: 0])
            }
            for row in table.body.rows {
                for (column, cell) in row.cells.enumerated() {
                    maxCharactersPerColumn[column] = max(cell.plainText.count, maxCharactersPerColumn[column, default: 0])
                }
            }
        }
        maxCharactersPerColumn = maxCharactersPerColumn.mapValues { value in
            return value + 2
        }
        
        let maxCharacters = maxCharactersPerColumn[tableCell.indexInParent, default: 0]
        let totalPadding = maxCharacters - tableCell.plainText.count
        let heading = AttributedString(String(repeating: " ", count: totalPadding/2))
        let tailing = AttributedString(String(repeating: " ", count: totalPadding/2 + (totalPadding%2 == 0 ? 0 : 1)))
        
        var string = tableCell.children
            .compactMap { heading + visit($0) + tailing }
            .reduce(into: AttributedString()) { $0.append($1) }
        string.font = style.tableCell.font
        
        if tableCell.parent?.childCount == tableCell.indexInParent + 1 {
            string += "\n"
        }
        
        return string
    }
   
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> AttributedString {
        var heading = AttributedString("❝ ")
        heading.font = Font.systemFont(ofSize: 32)
        heading.foregroundColor = style.blockQuote.foregroundColor
        
        var string = defaultVisit(blockQuote)
        string.font = style.blockQuote.font
        string.paragraphStyle = style.blockQuote.paragraphStyle
        string.foregroundColor = style.blockQuote.foregroundColor
        string.backgroundColor = style.blockQuote.backgroundColor
        
        return heading + string
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

