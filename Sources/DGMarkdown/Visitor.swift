//
//  Visitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Cocoa
import Markdown

struct Visitor {
    
}

extension Visitor: MarkupVisitor {
    
    typealias Result = NSAttributedString
    
    mutating func defaultVisit(_ markup: Markup) -> NSAttributedString {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
    }
    
    func visitText(_ text: Text) -> NSAttributedString {
        let style = Style.text
        return NSAttributedString(string: text.plainText, attributes: [
            .font: style.font
        ])
    }
    
    func visitInlineCode(_ inlineCode: InlineCode) -> NSAttributedString {
        let style = Style.inlineCode
        return NSAttributedString(string: inlineCode.code, attributes: [
            .font: style.font,
            .foregroundColor: style.foregroundColor,
            .backgroundColor: style.backgroundColor
        ])
    }
    
    mutating func visitParagraph(_ paragraph: Paragraph) -> NSAttributedString {
        let attributedString = paragraph.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
        attributedString.append(NSAttributedString(string: "\n"))
        return attributedString
    }
    
    mutating func visitHeading(_ heading: Heading) -> NSAttributedString {
        let attributedString = heading.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
        
        let style: Style
        switch heading.level {
        case 1: style = .h1
        case 2: style = .h2
        case 3: style = .h3
        default: style = .h4
        }
        attributedString.addAttribute(.font, value: style.font, range: NSRange(location: 0, length: attributedString.length))
        
        attributedString.append(NSAttributedString(string: "\n"))
        return attributedString
    }
    
    mutating func visitEmphasis(_ emphasis: Emphasis) -> NSAttributedString {
        let attributedString = emphasis.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
        attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, stop in
            let font = value as? NSFont ?? Style.emphasis.font
            attributedString.addAttribute(.font, value: font.italic(), range: range)
        }
        return attributedString
    }
    
    mutating func visitStrong(_ strong: Strong) -> NSAttributedString {
        let attributedString = strong.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
        attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, stop in
            let font = value as? NSFont ?? Style.strong.font
            attributedString.addAttribute(.font, value: font.bold(), range: range)
        }
        return attributedString
    }
    
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> NSAttributedString {
        let attributedString = strikethrough.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    mutating func visitLink(_ link: Link) -> NSAttributedString {
        let attributedString = link.children
            .compactMap { visit($0) }
            .reduce(into: NSMutableAttributedString()) { $0.append($1) }
    
        if let destination = link.destination, let link = URL(string: destination) {
            attributedString.addAttribute(.link, value: link, range: NSRange(location: 0, length: attributedString.length))
        }
        
        return attributedString
    }
    
    func visitLineBreak(_ lineBreak: LineBreak) -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
    func visitSoftBreak(_ softBreak: SoftBreak) -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
}

extension NSFont {
    
    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits) -> NSFont {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert(traits)
        
        let descriptor = fontDescriptor.withSymbolicTraits(symbolicTraits)
        return NSFont(descriptor: descriptor, size: 0)!
    }

    func bold() -> NSFont {
        return withTraits(.bold)
    }

    func italic() -> NSFont {
        return withTraits(.italic)
    }
    
}
