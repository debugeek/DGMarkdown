//  
//  DGMarkdown.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Markdown

public struct DGMarkdownOptions {
    public var generatesLineRange: Bool
    public static let `default` = DGMarkdownOptions(generatesLineRange: false)
}

public struct DGMarkdown {

    public var debugEnabled: Bool = false

    public init() {}
    
    private var document: Document?
    public mutating func parse(_ text: String) {
        document = Document(parsing: text)
        
#if DEBUG
        if debugEnabled, let document = document {
            print(document.debugDescription())
        }
#endif
    }

    public func html(_ options: DGMarkdownOptions = .default, imageModifier: ((String) -> String)? = nil) -> String? {
        guard
            let document = document
        else {
            return nil
        }
        
        var visitor = HTMLVisitor(options: options)
        visitor.imageModifier = imageModifier
        return visitor.visit(document)
    }
    
    public func tokens() -> [Token]? {
        guard
            let document = document
        else {
            return nil
        }
        
        var visitor = TokenVisitor()
        return visitor.visit(document)
    }
    
}
