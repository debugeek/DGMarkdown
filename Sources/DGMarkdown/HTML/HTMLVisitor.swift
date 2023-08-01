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
        return HTMLElement(tag: "p")
            .addContent(defaultVisit(paragraph))
            .build()
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Result {
        return HTMLElement(type: .void, tag: "br")
            .build()
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> Result {
        return HTMLElement(type:.void, tag: "br")
            .build()
    }
    
    mutating func visitText(_ text: Text) -> Result {
        return HTMLTextElement()
            .addContent(text.plainText)
            .setBoundingAttributes(text)
            .build()
    }
    
    mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        return HTMLElement(tag: "code")
            .addContent(inlineCode.code)
            .setBoundingAttributes(inlineCode)
            .build()
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        return HTMLElement(tag: "pre")
            .addContent(HTMLElement(tag: "code")
                .addContent(codeBlock.code)
                .setBoundingAttributes(codeBlock)
                .build())
            .build()
    }
    
    mutating func visitHeading(_ heading: Heading) -> Result {
        return HTMLElement(tag: "h\(heading.level)")
            .addContent(defaultVisit(heading))
            .build()
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> Result {
        return HTMLElement(tag: "em")
            .addContent(defaultVisit(emphasis))
            .build()
    }
    
    mutating func visitStrong(_ strong: Strong) -> Result {
        return HTMLElement(tag: "strong")
            .addContent(defaultVisit(strong))
            .build()
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Result {
        return HTMLElement(tag: "s")
            .addContent(defaultVisit(strikethrough))
            .build()
    }
    
    mutating func visitLink(_ link: Link) -> Result {
        return HTMLElement(tag: "a")
            .addContent(link.plainText)
            .setBoundingAttributes(link)
            .addAttribute("href", link.destination ?? "")
            .build()
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> Result {
        return HTMLElement(tag: "ol")
            .addContent(defaultVisit((orderedList)))
            .build()
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Result {
        return HTMLElement(tag: "ul")
            .addContent(defaultVisit((unorderedList)))
            .build()
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> Result {
        if let checkbox = listItem.checkbox {
            return defaultVisit(listItem)
                .replacingOccurrences(of: "<p>", with: "<p><input type=\"checkbox\" \(checkbox == .checked ? "checked" : "") />")
        } else {
            return HTMLElement(tag: "li")
                .addContent(defaultVisit((listItem)))
                .build()
        }
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        return HTMLElement(type: .void, tag: "hr")
            .setBoundingAttributes(thematicBreak)
            .build()
    }
    
    mutating func visitTable(_ table: Table) -> Result {
        return HTMLElement(tag: "table")
            .addContent(defaultVisit((table)))
            .build()
    }
    
    mutating func visitTableHead(_ tableHead: Table.Head) -> Result {
        return HTMLElement(tag: "thead")
            .addContent(defaultVisit((tableHead)))
            .build()
            .replacingOccurrences(of: "<td", with: "<th")
            .replacingOccurrences(of: "</td", with: "</th")
    }
    
    mutating func visitTableBody(_ tableBody: Table.Body) -> Result {
        return HTMLElement(tag: "tbody")
            .addContent(defaultVisit((tableBody)))
            .build()
    }
    
    mutating func visitTableRow(_ tableRow: Table.Row) -> Result {
        return HTMLElement(tag: "tr")
            .addContent(defaultVisit(tableRow))
            .build()
    }
    
    mutating func visitTableCell(_ tableCell: Table.Cell) -> Result {
        let align: String
        if let table = tableCell.parent?.parent?.parent as? Table ?? tableCell.parent?.parent as? Table,
           let columnAlignment = table.columnAlignments[tableCell.indexInParent] {
            switch columnAlignment {
                case .left: align = "left"
                case .center: align = "center"
                case .right: align = "right"
            }
        } else {
            align = "center"
        }
        return HTMLElement(tag: "td")
            .addAttribute("align", align)
            .addContent(defaultVisit((tableCell)))
            .build()
    }
    
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        return HTMLElement(tag: "blockquote")
            .addContent(defaultVisit((blockQuote)))
            .build()
    }
    
    mutating func visitImage(_ image: Image) -> Result {
        return HTMLElement(type: .void, tag: "img")
            .addAttribute("src", image.source ?? "")
            .setBoundingAttributes(image)
            .build()
    }
    
    mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
        return html.rawHTML
    }
    
    mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Result {
        return inlineHTML.rawHTML
    }

}
