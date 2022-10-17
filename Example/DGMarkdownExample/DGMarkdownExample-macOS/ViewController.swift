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
    
    private lazy var style: Style = { Style() }()
}

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let attributedString = DGMarkdown.attributedString(fromMarkdownText: editTextView.string, style: style)
        previewTextView.textStorage?.setAttributedString(NSAttributedString(attributedString))
    }
    
}

