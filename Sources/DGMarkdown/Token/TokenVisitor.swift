//
//  TokenVisitor.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 15/9/25.
//

import Foundation
import Markdown

enum TokenType {
    case heading1
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
}

public struct SourceLocation {
    let line: Int
}

public struct SourceRange {
    let lowerBound: SourceLocation
    let upperBound: SourceLocation
}

public struct Token {
    let type: TokenType
    let text: String
    let range: SourceRange?
}

struct TokenVisitor: MarkupVisitor {

    typealias Result = [Token]
    
    func sourceRange(from markup: Markup) -> SourceRange? {
        guard
            let lowerBound = markup.range?.lowerBound,
            let upperBound = markup.range?.upperBound
        else {
            return nil
        }
        
        return SourceRange(lowerBound: SourceLocation(line: lowerBound.line),
                           upperBound: SourceLocation(line: upperBound.line))
    }
    
    mutating func defaultVisit(_ markup: Markup) -> Result {
        return markup.children
            .compactMap { visit($0) }
            .reduce(into: [Token]()) { $0.append(contentsOf: $1) }
    }
    
    mutating func visitHeading(_ heading: Heading) -> Result {
        let types: [Int: TokenType] = [
            1: .heading1,
            2: .heading2,
            3: .heading3,
            4: .heading4,
            5: .heading5,
            6: .heading6
        ]
        
        guard
            let type = types[heading.level]
        else {
            return []
        }
        
        return [Token(type: type, text:heading.plainText, range: sourceRange(from: heading))]
    }

}

