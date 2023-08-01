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
