//
//  ViewController.swift
//  DGMarkdownExample-iOS
//
//  Created by Xiao Jin on 2022/9/9.
//  Copyright © 2022 debugeek. All rights reserved.
//

import UIKit
import DGMarkdown

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let text = """
# h1 Heading
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading

------

# Emphasis

Emphasis, aka italics, with *asterisks* or _underscores_.

Strong emphasis, aka bold, with **asterisks** or __underscores__.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~

**This is bold text**

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~

------

# List

1. Item A
2. Item B
  * Item B.1
  * Item B.2
1. Item C
  1. Item C.1
  2. Item C.2
4. Item D

------

# Task list

- [x] Option A
- [ ] Option B

------

# Link

[Google.com](https://www.google.com "Google")

------

# Image

![Avatar](https://avatars.githubusercontent.com/u/5179153)

------

# Table

| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

------

# Blockquote

> Text A

> Text B
>> Text B.1
> > > Text B.2

# Code Block

```swift
extension Markup {
    
    func isContained<T: Markup>(inMarkupWithType type: T.Type) -> Bool {
        var parent = parent
        while parent != nil {
            if parent is T {
                return true
            }
            parent = parent?.parent
        }
        return false
    }
    
}
```
"""
        let markdown = DGMarkdown(delegate: self)
        let attributedString = markdown.attributedString(fromMarkdownText: text)
        textView.attributedText = NSAttributedString(attributedString)
    }

}

extension ViewController: DGMarkdownDelegate {

    func processImage(withURL url: URL, title: String?, forAttachment attachment: NSTextAttachment) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                attachment.image = image
                attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                DispatchQueue.main.sync {
                    let characterRange = NSMakeRange(0, self.textView.attributedText.length)
                    self.textView.layoutManager.invalidateLayout(forCharacterRange: characterRange, actualCharacterRange: nil)
                }
            }
        }
    }

}
