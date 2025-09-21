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
    
    let options: DGMarkdownOptions
    
    var imageModifier: ((String) -> String)?
    
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
        return HTMLElement(tag: "span")
            .addContent(text.plainText)
            .when(options.generatesLineRange) { $0.setBoundingAttributes(text) }
            .build()
    }
    
    mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        return HTMLElement(tag: "code")
            .addContent(inlineCode.code, encode: true)
            .when(options.generatesLineRange) { $0.setBoundingAttributes(inlineCode) }
            .build()
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        let language = codeBlock.language ?? ""
        return HTMLElement(tag: "pre")
            .addContent(HTMLElement(tag: "code")
                .addContent(codeBlock.code, encode: true)
                .when(!language.isEmpty) { $0.addAttribute("class", "language-\(language)") }
                .when(options.generatesLineRange) { $0.setBoundingAttributes(codeBlock) }
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
        return HTMLElement(tag: "del")
            .addContent(defaultVisit(strikethrough))
            .build()
    }
    
    mutating func visitLink(_ link: Link) -> Result {
        return HTMLElement(tag: "a")
            .addContent(link.title ?? defaultVisit(link))
            .when(options.generatesLineRange) { $0.setBoundingAttributes(link) }
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
            let input = HTMLElement(type: .void, tag: "input")
                .addContent(defaultVisit(listItem))
                .addAttribute("type", "checkbox")
                .when(checkbox == .checked) { $0.addAttribute("checked") }
                .when(options.generatesLineRange) { $0.setBoundingAttributes(listItem) }
                .build()
            return defaultVisit(listItem)
                .replacingOccurrences(of: "<p>", with: "<p>\(input)")
        } else {
            return HTMLElement(tag: "li")
                .addContent(defaultVisit((listItem)))
                .build()
        }
    }

    func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        return HTMLElement(type: .void, tag: "hr")
            .when(options.generatesLineRange) { $0.setBoundingAttributes(thematicBreak) }
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
        var src = image.source ?? ""
        if let imageModifier = imageModifier {
            src = imageModifier(src)
        }
        return HTMLElement(type: .void, tag: "img")
            .addAttribute("src", src)
            .when(options.generatesLineRange) { $0.setBoundingAttributes(image) }
            .build()
    }
    
    mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
        return html.rawHTML
    }
    
    mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Result {
        return inlineHTML.rawHTML
    }

}
