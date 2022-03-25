import SwiftSyntax
import Foundation
import Theme

public extension String {
    func highlightSwiftCode() -> AttributedString? {
        guard let parsed = try? SyntaxParser.parse(source: self) else { return nil  }
        let highlighter = CodeHighlighter(code: self)
        _ = highlighter.visit(parsed)
        var attributedString = AttributedString(self)
        highlighter
            .tokens
            .map { $0.attributes(in: (NSRange(self)!, self)) }
            .forEach {
                let range = Range<AttributedString.Index>.init($0.range, in: attributedString)!
                attributedString[range].setAttributes($0.attributes)
            }
        
        attributedString.backgroundColor = Asset.codeBackground.color
        
        return attributedString
    }
}
