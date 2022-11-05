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
        
    public var debugEnabled = false

    public var styleSheet = StyleSheet()

    public init() {}
    
    public func attributedString(fromMarkdownText text: String) -> AttributedString {
        let document = Document(parsing: text)
        
        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif
        
        var visitor = Visitor(styleSheet: styleSheet)
        let attributedString = visitor.visit(document)
        return attributedString
    }
    
}
