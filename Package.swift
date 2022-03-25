// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeHighlighter",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "CodeHighlighter",
            targets: ["CodeHighlighter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", revision: "593d01f4017cf8b71ec28689629f7b9a6739df0b")
    ],
    targets: [
        .target(
            name: "CodeHighlighter",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                "InternalSwiftSyntaxParser",
                "Theme"
            ]
        ),
        .target(
            name: "Theme",
            resources: [.process("Resources")],
            plugins: ["SwiftGen"]),
        .testTarget(name: "CodeHighlighterTests", dependencies: ["CodeHighlighter"]),
        .binaryTarget(name: "InternalSwiftSyntaxParser", url: "https://github.com/pol-piella/swift-highlight/releases/download/v0.0.1/swift-syntax.xcframework.zip", checksum: "9b3de0046ffaab16288cc3503023e46d00208707eb74873783f091b74aface05"),
        .binaryTarget(name: "swiftgen", url: "https://github.com/pol-piella/swift-highlight/releases/download/v0.0.1/swiftgen.zip", checksum: "82d29e4127cb354b7d278b781d3b9743febd9c4e4a215e56ee3f67400e02aa1f"),
        .plugin(name: "SwiftGen", capability: .buildTool(), dependencies: ["swiftgen"])
    ]
)
