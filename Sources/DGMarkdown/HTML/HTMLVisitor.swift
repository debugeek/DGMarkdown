//
//  HTMLVisitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2023/3/3.
//  Copyright © 2023 debugeek. All rights reserved.
//

import Foundation
import Markdown

struct HTMLVisitor: MarkupVisitor {
    
    typealias Result = String
    
    mutating func defaultVisit(_ markup: Markup) -> Result {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: String()) { $0.append($1) }
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> Result {
        return "<p>"
            .appending(defaultVisit(paragraph))
            .appending("</p>")
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Result {
        return "<br>"
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> Result {
        return "<br>"
    }
    
    mutating func visitText(_ text: Text) -> Result {
        return text.plainText
    }
    
    mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        return "<code>\(inlineCode.code)</code>"
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        return "<pre><code>\(codeBlock.code)</code></pre>"
    }
    
    mutating func visitHeading(_ heading: Heading) -> Result {
        return "<h\(heading.level)>"
            .appending(defaultVisit(heading))
            .appending("</h\(heading.level)>")
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> Result {
        return "<em>"
            .appending(defaultVisit(emphasis))
            .appending("</em>")
    }
    
    mutating func visitStrong(_ strong: Strong) -> Result {
        return "<strong>"
            .appending(defaultVisit(strong))
            .appending("</strong>")
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Result {
        return "<s>"
            .appending(defaultVisit(strikethrough))
            .appending("</s>")
    }
    
    mutating func visitLink(_ link: Link) -> Result {
        return "<a href=\"\(link.destination ?? "")\">"
            .appending(link.plainText)
            .appending("</a>")
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> Result {
        return "<ol>"
            .appending(defaultVisit(orderedList))
            .appending("</ol>")
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Result {
        return "<ul>"
            .appending(defaultVisit(unorderedList))
            .appending("</ul>")
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> Result {
        if let checkbox = listItem.checkbox {
            return defaultVisit(listItem)
                .replacingOccurrences(of: "<p>", with: "<p><input type=\"checkbox\" \(checkbox == .checked ? "checked" : "") />")
        } else {
            return "<li>"
                .appending(defaultVisit(listItem))
                .appending("</li>")
        }
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        return "<hr/>"
    }
    
    mutating func visitTable(_ table: Table) -> Result {
        return "<table>\(defaultVisit(table))</table>"
    }
    
    mutating func visitTableHead(_ tableHead: Table.Head) -> Result {
        return "<thead>\(defaultVisit(tableHead))</thead>"
            .replacingOccurrences(of: "<td>", with: "<th>")
            .replacingOccurrences(of: "</td>", with: "</th>")
    }
    
    mutating func visitTableBody(_ tableBody: Table.Body) -> Result {
        return "<tbody>\(defaultVisit(tableBody))</tbody>"
    }
    
    mutating func visitTableRow(_ tableRow: Table.Row) -> Result {
        return "<tr>\(defaultVisit(tableRow))</tr>"
    }
    
    mutating func visitTableCell(_ tableCell: Table.Cell) -> Result {
        return "<td>\(defaultVisit(tableCell))</td>"
    }
    
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        return "<blockquote>"
            .appending(defaultVisit(blockQuote))
            .appending("</blockquote>")
    }
    
    mutating func visitImage(_ image: Image) -> Result {
        return "<img src=\"\(image.source ?? "")\" alt=\"\(defaultVisit(image))\" />"
    }
    
    mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
        return html.rawHTML
    }
    
    mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Result {
        return inlineHTML.rawHTML
    }

}
