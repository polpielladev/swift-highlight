#!/usr/bin/env bash

# Halt on errors, unset vars or pipeline errors
set -euo pipefail

# Print out statements (with vars expanded) before executing
set -x

# Checkouts

if [ ! -d ".checkouts" ]; then
    mkdir .checkouts && pushd .checkouts
    git clone https://github.com/apple/swift.git
    ./swift/utils/update-checkout --clone --scheme release/5.5
    popd
fi

# Set working directory
rm -rf .build && mkdir .build && pushd .build

# Create a directory for the syntax parser
../.checkouts/swift/utils/build-parser-lib --release --no-assertions --build-dir /tmp/parser-lib-build-iossim --host iphonesimulator --architectures x86_64
../.checkouts/swift/utils/build-parser-lib --release --no-assertions --build-dir /tmp/parser-lib-build-ios --host iphoneos --architectures arm64
../.checkouts/swift/utils/build-parser-lib --release --no-assertions --build-dir /tmp/parser-lib-build --architectures x86_64

rm -rf artifacts && mkdir -p artifacts/simulator && mkdir -p artifacts/device && mkdir -p artifacts/include && mkdir -p artifacts/macosx
mv /tmp/parser-lib-build-iossim/x86_64/dst/lib/swift/iphonesimulator/lib_InternalSwiftSyntaxParser.dylib artifacts/simulator/lib_InternalSwiftSyntaxParser.dylib
mv /tmp/parser-lib-build-ios/arm64/dst/lib/swift/iphoneos/lib_InternalSwiftSyntaxParser.dylib artifacts/device/lib_InternalSwiftSyntaxParser.dylib
mv /tmp/parser-lib-build-iossim/x86_64/dst/lib/swift/_InternalSwiftSyntaxParser/SwiftSyntaxParser.h artifacts/include/SwiftSyntaxParser.h
mv /tmp/parser-lib-build/x86_64/dst/lib/swift/macosx/lib_InternalSwiftSyntaxParser.dylib artifacts/macosx/lib_InternalSwiftSyntaxParser.dylib

rm -rf ../InternalSwiftSyntaxParser.xcframework
xcrun xcodebuild -create-xcframework \
    -library artifacts/simulator/lib_InternalSwiftSyntaxParser.dylib -headers artifacts/include \
    -library artifacts/device/lib_InternalSwiftSyntaxParser.dylib  -headers artifacts/include \
    -library artifacts/macosx/lib_InternalSwiftSyntaxParser.dylib  -headers artifacts/include \
    -output ../InternalSwiftSyntaxParser.xcframework

popd
