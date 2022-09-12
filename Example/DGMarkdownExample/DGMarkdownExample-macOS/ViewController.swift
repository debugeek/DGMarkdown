//
//  ViewController.swift
//  DGMarkdownExample-macOS
//
//  Created by Xiao Jin on 2022/8/27.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Cocoa
import DGMarkdown

class ViewController: NSViewController {

    @IBOutlet var editTextView: NSTextView!
    @IBOutlet var previewTextView: NSTextView!
    
}

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        DGMarkdown.parse(text: editTextView.string, style: Style()) { attributedString in
            self.previewTextView.textStorage?.setAttributedString(NSAttributedString(attributedString))
        }
    }
    
}

