//
//  AttributedDelegate.swift
//  DGMarkdown
//
//  Created by Xiao Jin on 2023/3/4.
//  Copyright © 2023 debugeek. All rights reserved.
//

#if canImport(Cocoa)
import AppKit
#else
import UIKit
#endif

import Foundation

public protocol AttributedDelegate: AnyObject {

    func processImage(withURL url: URL, title: String?, forAttachment attachment: NSTextAttachment)

}
