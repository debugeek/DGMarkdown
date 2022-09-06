//
//  Syntax.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/9/6.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Cocoa
import DGExtension

struct Syntax {
    
    static func highlighted(withCode code: String, style: CodeBlockStyle, languageIdentifier: String?) -> AttributedString {
        var string = AttributedString(code)
        string.font = style.font
        string.paragraphStyle = style.paragraphStyle
        string.foregroundColor = style.foregroundColor
        string.backgroundColor = style.backgroundColor
        string.languageIdentifier = languageIdentifier
        
        let language: Language
        switch languageIdentifier?.lowercased() {
        case "swift": language = Swift()
        default: language = Default()
        }
        for pattern in language.patterns {
            guard let rgx = try? NSRegularExpression(pattern: pattern.pattern) else {
                continue
            }
            
            let results = rgx.matches(in: code, range: NSRange(location: 0, length: code.count))
            for result in results {
                guard let range = Range(result.range, in: string) else {
                    continue
                }
                string[range].font = pattern.font
                string[range].foregroundColor = pattern.foregroundColor
            }
        }
        
        return string
    }
    
}

struct Pattern {
    let pattern: String
    let font: NSFont?
    let foregroundColor: NSColor?
}

protocol Language {
    var patterns: [Pattern] { get }
}

struct Default: Language {
    var patterns: [Pattern] {
        return []
    }
}

struct Swift: Language {
    
    var patterns: [Pattern] {
        return [
            // keywords
            Pattern(pattern: "\\b(actor|any|associatedtype|async|await|as(\\?|!)?|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|distributed|do|dynamic|else|enum|extension|fallthrough|fileprivate(\\(set\\))?|final|for|func|get|guard|if|import|indirect|infix|init(\\?|!)?|inout|internal(\\(set\\))?|in|is|isolated|nonisolated|lazy|let|mutating|nonmutating|open(\\(set\\))?|operator|optional|override|postfix|precedencegroup|prefix|private(\\(set\\))?|protocol|public(\\(set\\))?|repeat|required|rethrows|return|set|some|static|struct|subscript|super|switch|throws|throw|try(\\?|!)?|typealias|unowned(safe|unsafe)?|var|weak|where|while|willSet)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC5FA3)),

            // literals
            Pattern(pattern: "\\b(true|false|nil)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC5FA3)),
            
            // precedencegroupKeywords
            Pattern(pattern: "\\b(assignment|associativity|higherThan|left|lowerThan|none|right)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC5FA3)),
            
            // numberSignKeywords
            Pattern(pattern: "#(colorLiteral|column|dsohandle|else|elseif|endif|error|file|fileID|fileLiteral|filePath|function|if|imageLiteral|keyPath|line|selector|sourceLocation|warn_unqualified_access|warning)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC5FA3)),
            
            // keywordAttributes
            Pattern(pattern: "@(autoclosure|convention|discardableResult|dynamicCallable|dynamicMemberLookup|escaping|frozen|GKInspectable|IBAction|IBDesignable|IBInspectable|IBOutlet|IBSegueAction|inlinable|main|nonobjc|NSApplicationMain|NSCopying|NSManaged|objc|objc|objcMembers|propertyWrapper|requires_stored_property_inits|resultBuilder|testable|UIApplicationMain|unknown|usableFromInline)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC5FA3)),
            
            // types
            Pattern(pattern: "\\b(Int|String)\\b",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0x9EF1DD)),
            
            // strings
            Pattern(pattern: "(\".*\")",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0xFC6A5D)),
            
            // comment line
            Pattern(pattern: "(//.*)",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0x6C7986)),
            
            // comment block
            Pattern(pattern: "(/\\*.*?\\*/)",
                    font: NSFont.monospacedSystemFont(ofSize: 16, weight: .regular),
                    foregroundColor: NSColor.color(withHex: 0x6C7986))
            ]
    }
    
}
