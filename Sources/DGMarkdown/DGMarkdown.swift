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
    public let generatesLineRange: Bool
    public static let `default` = DGMarkdownOptions(generatesLineRange: false)
}

public struct DGMarkdown {

    public var debugEnabled: Bool = false

    public init() {}

    public func HTMLString(fromMarkdownText text: String, options: DGMarkdownOptions = .default) -> String {
        let document = Document(parsing: text)

        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif

        var visitor = HTMLVisitor(options: options)
        let string = visitor.visit(document)
        return string
    }
    
}
