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
import Cocoa
#else
import UIKit
#endif

public protocol DGMarkdownDelegate: AnyObject {

#if canImport(Cocoa)
    func fetchImage(withURL url: URL, title: String?, completion: @escaping ((image: NSImage, bounds: CGRect)?) -> Void)
#else
    func fetchImage(withURL url: URL, title: String?, completion: @escaping ((image: UIImage, bounds: CGRect)?) -> Void)
#endif

    func invalidateLayout()
    
}

public struct DGMarkdown {

    public let debugEnabled: Bool

    public let styleSheet: StyleSheet

    private weak var delegate: DGMarkdownDelegate?

    public init(delegate: DGMarkdownDelegate?,
                styleSheet: StyleSheet = StyleSheet(),
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
