//
//  HTMLElement.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2023/7/3.
//  Copyright © 2023 debugeek. All rights reserved.
//

import Foundation
import Markdown

struct HTMLAttribute {
    let name: String
    let value: String
}

enum HTMLElementType {
    case `default`
    case void
}

class HTMLElement {

    let type: HTMLElementType
    let tag: String?

    var content: String = ""

    var attributes = [HTMLAttribute]()

    init(type: HTMLElementType = .default, tag: String? = nil) {
        self.type = type
        self.tag = tag
    }

    @discardableResult
    func addAttribute(_ name: String, _ value: String) -> Self {
        self.attributes.append(HTMLAttribute(name: name, value: value))
        return self
    }

    @discardableResult
    func addContent(_ content: String) -> Self {
        self.content.append(content)
        return self
    }

    @discardableResult
    func setBoundingAttributes(_ markup: Markup) -> Self {
        if let range = markup.range {
            self.addAttribute("begin-line", "\(range.lowerBound.line)")
            self.addAttribute("end-line", "\(range.upperBound.line)")
        }
        return self
    }

    func build() -> String {
        var element = ""

        if let tag = tag {
            element += "<\(tag)"

            let attributes = attributes.map { "\($0.name)='\($0.value)'" }.joined(separator: " ")
            if attributes.count > 0 {
                element += " \(attributes)"
            }
            element += ">"

            if type == .default {
                element += content
                element += "</\(tag)>"
            }
        } else {
            element += content
        }

        return element
    }

    func when(_ condition: Bool, _ block: ((HTMLElement) -> Void)) -> Self {
        if condition {
            block(self)
        }
        return self
    }
    
}
