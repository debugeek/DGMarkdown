//
//  Visitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
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
    
}
