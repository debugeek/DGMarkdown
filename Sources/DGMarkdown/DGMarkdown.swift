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
    
    private static let queue = DispatchQueue(label: "com.debugeek.markdown")
    
    public static func parse(_ text: String, using block: @escaping (NSAttributedString) -> Void) {
        queue.async {
            let document = Document(parsing: text)
            
            #if DEBUG
            print(document.debugDescription())
            #endif
            
            var visitor = Visitor()
            let result = visitor.visit(document)
            
            DispatchQueue.main.async {
                block(result)
            }
        }
        
    }
    
}
