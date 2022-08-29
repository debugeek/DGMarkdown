//
//  ViewController.swift
//  DGMarkdownExample-macOS
//
//  Created by Xiao Jin on 2022/8/27.
//

import Cocoa
import DGMarkdown

class ViewController: NSViewController {

    @IBOutlet var editTextView: NSTextView!
    @IBOutlet var previewTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
}

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        DGMarkdown.parse(editTextView.string) { attributedString in
            self.previewTextView.textStorage?.setAttributedString(NSAttributedString(attributedString))
        }
    }
    
}

