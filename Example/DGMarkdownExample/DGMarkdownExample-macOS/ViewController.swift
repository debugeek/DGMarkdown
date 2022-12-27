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
        let markdown = DGMarkdown(delegate: self)
        let attributedString = markdown.attributedString(fromMarkdownText: editTextView.string)
        previewTextView.textStorage?.setAttributedString(NSAttributedString(attributedString))
    }
    
}

extension ViewController: DGMarkdownDelegate {

    func fetchImage(withURL url: URL, title: String?, completion: @escaping ((image: NSImage, bounds: CGRect)?) -> Void) {
        DispatchQueue.global().async {
            if let image = NSImage(contentsOf: url) {
                DispatchQueue.main.sync {
                    let result = (image, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                    completion(result)
                }
            }
        }
    }

    func invalidateLayout() {
        self.previewTextView.layoutManager?.invalidateLayout(forCharacterRange: NSMakeRange(0, self.previewTextView.attributedString().length), actualCharacterRange: nil)
    }

}

