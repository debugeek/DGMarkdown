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
    
    private func transform(string: String, markup: Markup) -> Result {
        let style: Style
        switch markup.parent ?? markup {
        case let heading as Heading:
            switch heading.level {
            case 1: style = .h1
            case 2: style = .h2
            case 3: style = .h3
            default: style = .h4
            }
        default: style = .body
        }
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: style.font,
            .paragraphStyle: style.paragraphStyle,
            .foregroundColor: style.foregroundColor,
            .backgroundColor: style.backgroundColor,
        ])
        
        switch markup {
        case let link as Link:
            if let destination = link.destination, let url = URL(string: destination) {
                attributedString.addAttribute(.link, value: url, range: NSRange(location: 0, length: string.count))
            }
            
        default: break
        }
        
        attributedString.append(NSAttributedString(string: "\n"))
        
        return attributedString
    }
    
}

extension Visitor: MarkupVisitor {
    
    mutating func defaultVisit(_ markup: Markup) -> NSAttributedString {
        transform(string: markup.format(), markup: markup)
    }
    
    typealias Result = NSAttributedString
    
    public mutating func visit(_ markup: Markup) -> Result {
        guard markup.childCount > 0 else {
            return markup.accept(&self)
        }
        
        return markup.children.compactMap { child -> Result in
            if child is Text {
                return child.accept(&self)
            } else {
                return visit(child)
            }
        }.reduce(into: NSMutableAttributedString()) { partialResult, attributedString in
            partialResult.append(attributedString)
        }
    }
    
}
