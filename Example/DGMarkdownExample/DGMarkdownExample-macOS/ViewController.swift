//
//  ViewController.swift
//  DGMarkdownExample-macOS
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Cocoa
import WebKit
import DGMarkdown

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layoutManager?.allowsNonContiguousLayout = true
    }
    
}

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let markdown = DGMarkdown()
        let string = markdown.HTMLString(fromMarkdownText: textView.string)
        webView.loadHTMLString(string, baseURL: nil)
    }
    
}
