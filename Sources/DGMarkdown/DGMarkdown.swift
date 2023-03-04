//  
//  DGMarkdown.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Markdown

public struct DGMarkdown {

    public var debugEnabled: Bool = false

    public init() {}

    public func attributedString(fromMarkdownText text: String,
                                 styleSheet: AttributedStyleSheet = AttributedStyleSheet(),
                                 delegate: AttributedDelegate? = nil) -> NSAttributedString {
        let document = Document(parsing: text)
        
        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif
        
        var visitor = AttributedVisitor(delegate: delegate, styleSheet: styleSheet)
        let attributedString = visitor.visit(document)
        return attributedString
    }

    public func HTMLString(fromMarkdownText text: String) -> String {
        let document = Document(parsing: text)

        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif

        var visitor = HTMLVisitor()
        let string = visitor.visit(document)
        return string
    }
    
}
