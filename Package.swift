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
        .binaryTarget(name: "InternalSwiftSyntaxParser", path: "InternalSwiftSyntaxParser.xcframework"),
        .binaryTarget(name: "swiftgen", path: "./swiftgen.artifactbundle"),
        .plugin(name: "SwiftGen", capability: .buildTool(), dependencies: ["swiftgen"])
    ]
)
