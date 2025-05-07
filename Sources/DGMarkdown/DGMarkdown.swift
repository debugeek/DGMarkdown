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

    public func html(from markdown: String, options: DGMarkdownOptions = .default, imageModifier: ((String) -> String)? = nil) -> String {
        let document = Document(parsing: markdown)

        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif

        var visitor = HTMLVisitor(options: options)
        visitor.imageModifier = imageModifier
        return visitor.visit(document)
    }
    
}
