// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DGMarkdown",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "DGMarkdown", targets: ["DGMarkdown"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
        .package(url: "https://github.com/debugeek/DGExtension.git", branch: "main"),
        .package(url: "https://github.com/debugeek/DGSyntaxHighlighter.git", branch: "main"),
    ],
    targets: [
        .target(name: "DGMarkdown", dependencies: [
            .product(name: "Markdown", package: "swift-markdown"),
            .product(name: "DGExtension", package: "DGExtension"),
            .product(name: "DGSyntaxHighlighter", package: "DGSyntaxHighlighter")
        ])
    ]
)
