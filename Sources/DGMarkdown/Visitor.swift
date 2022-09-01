//
//  Visitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Cocoa
import Markdown

struct Visitor {
        
}

extension Visitor: MarkupVisitor {
    
    typealias Result = AttributedString
    
    mutating func defaultVisit(_ markup: Markup) -> AttributedString {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
    }
    
    func visitText(_ text: Text) -> AttributedString {
        var string = AttributedString(text.plainText)
        string.font = Style.text.font
        string.foregroundColor = Style.text.foregroundColor
        return string
    }
    
    func visitInlineCode(_ inlineCode: InlineCode) -> AttributedString {
        var string = AttributedString(inlineCode.code)
        string.font = Style.inlineCode.font
        string.foregroundColor = Style.inlineCode.foregroundColor
        string.backgroundColor = Style.inlineCode.backgroundColor
        return string
    }
    
    func visitCodeBlock(_ codeBlock: CodeBlock) -> AttributedString {
        var string = AttributedString(codeBlock.code)
        string.font = Style.codeBlock.font
        string.foregroundColor = Style.codeBlock.foregroundColor
        string.backgroundColor = Style.codeBlock.backgroundColor
        string.inlinePresentationIntent = .code
        string.languageIdentifier = codeBlock.language
        return string
    }
    
    mutating func visitParagraph(_ paragraph: Paragraph) -> AttributedString {
        return paragraph.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) } + "\n"
    }
    
    mutating func visitHeading(_ heading: Heading) -> AttributedString {
        return heading.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
            .transformingAttributes(\.font) { transformer in
                let style: Style
                switch heading.level {
                case 1: style = .h1
                case 2: style = .h2
                case 3: style = .h3
                default: style = .h4
                }
                transformer.value = style.font
            } + "\n"
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> AttributedString {
        return emphasis.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
            .transformingAttributes(\.font) { transformer in
            transformer.value = Style.emphasis.font
        }
    }
    
    mutating func visitStrong(_ strong: Strong) -> AttributedString {
        return strong.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
            .transformingAttributes(\.font) { transformer in
            transformer.value = Style.strong.font
        }
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> AttributedString {
        var string = strikethrough.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
        string.strikethroughStyle = .single
        return string
    }
    
    mutating func visitLink(_ link: Link) -> AttributedString {
        var string = link.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
        if let destination = link.destination, let link = URL(string: destination) {
            string.link = link
        }
        return string
    }
    
    func visitLineBreak(_ lineBreak: LineBreak) -> AttributedString {
        var string = AttributedString("\n")
        string.inlinePresentationIntent = .lineBreak
        return string
    }
    
    func visitSoftBreak(_ softBreak: SoftBreak) -> AttributedString {
        var string = AttributedString("\n")
        string.inlinePresentationIntent = .softBreak
        return string
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> AttributedString {
        var depth = 1
        var parent = listItem.parent
        while parent != nil {
            if parent is ListItem {
                depth += 1
            }
            parent = parent?.parent
        }
        
        let prefix: String
        if listItem.parent is OrderedList {
            prefix = "\(listItem.indexInParent + 1)."
        } else {
            prefix = "•"
        }
        
        let spacing = String(repeating: " ", count: 2*depth)
        var string = AttributedString("\(spacing)\(prefix) ")
        string += listItem.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
        
        let style: Style
        switch depth {
        case 1: style = .listItem1
        case 2: style = .listItem2
        case 3: style = .listItem3
        default: style = .listItem4
        }
        string.font = style.font
        string.foregroundColor = style.foregroundColor
        return string
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> AttributedString {
        var string = AttributedString("\n \u{00a0} \n")
        string.strikethroughStyle = .single
        string.strikethroughColor = Style.thematicBreak.foregroundColor
        return string
    }
    
    mutating func visitTable(_ table: Table) -> AttributedString {
        return "\n" + table.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) } + "\n"
    }
    
    mutating func visitTableHead(_ tableHead: Table.Head) -> AttributedString {
        return tableHead.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
            .transformingAttributes(\.font) { transformer in
                transformer.value = Style.tableHead.font
            }
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
            .transformingAttributes(\.font) { transformer in
                transformer.value = Style.tableCell.font
            }
        
        if tableCell.parent?.childCount == tableCell.indexInParent + 1 {
            string += "\n"
        }
        
        return string
    }
   
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> AttributedString {
        var heading = AttributedString("❝ ")
        heading.font = NSFont.systemFont(ofSize: 40)
        heading.foregroundColor = Style.blockQuote.foregroundColor
        
        var string = blockQuote.children
            .compactMap { visit($0) }
            .reduce(into: AttributedString()) { $0.append($1) }
        string.font = Style.blockQuote.font
        string.foregroundColor = Style.blockQuote.foregroundColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        string.paragraphStyle = paragraphStyle
        
        return heading + string
    }

}

