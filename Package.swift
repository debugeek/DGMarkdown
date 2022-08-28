// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DGMarkdown",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "DGMarkdown", targets: ["DGMarkdown"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", .branch("main"))
    ],
    targets: [
        .target(name: "DGMarkdown", dependencies: [.product(name: "Markdown", package: "swift-markdown")])
    ]
)
