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
        
    public static var debugEnabled = false
    
    public static func attributedString(fromMarkdownText text: String, style: Style) -> AttributedString {
        let document = Document(parsing: text)
        
        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif
        
        var visitor = Visitor(style: style)
        let attributedString = visitor.visit(document)
        return attributedString
    }
    
}
