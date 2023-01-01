//  
//  DGMarkdown.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation
import Markdown

#if canImport(Cocoa)
import AppKit
#else
import UIKit
#endif

public protocol DGMarkdownDelegate: AnyObject {

    func processImage(withURL url: URL, title: String?, forAttachment attachment: NSTextAttachment)
    
}

public struct DGMarkdown {

    public let debugEnabled: Bool

    public let styleSheet: DGMarkdownStyleSheet

    private weak var delegate: DGMarkdownDelegate?

    public init(delegate: DGMarkdownDelegate? = nil,
                styleSheet: DGMarkdownStyleSheet = DGMarkdownStyleSheet(),
                debugEnabled: Bool = false) {
        self.delegate = delegate
        self.styleSheet = styleSheet
        self.debugEnabled = debugEnabled
    }

    public func attributedString(fromMarkdownText text: String) -> AttributedString {
        let document = Document(parsing: text)
        
        #if DEBUG
        if debugEnabled {
            print(document.debugDescription())
        }
        #endif
        
        var visitor = Visitor(delegate: delegate, styleSheet: styleSheet)
        let attributedString = visitor.visit(document)
        return attributedString
    }
    
}
