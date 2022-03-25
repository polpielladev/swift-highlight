import SwiftSyntax
import Foundation

final class CodeHighlighter: SyntaxRewriter {
    private(set) var tokens: [CodeToken] = []
    let code: String
    
    init(code: String) {
        self.code = code
    }

    override func visit(_ token: TokenSyntax) -> Syntax {
        let start = code.utf8.index(code.utf8.startIndex, offsetBy: token.positionAfterSkippingLeadingTrivia.utf8Offset)
        let end = code.utf8.index(code.utf8.startIndex, offsetBy: token.endPosition.utf8Offset)

        switch token.tokenKind {
        case .stringSegment, .stringQuote, .stringLiteral:
            tokens.append(CodeToken(range: start..<end, kind: .string))
        case let kind where kind.isKeyword:
            tokens.append(CodeToken(range: start..<end, kind: .keyword))
        case .floatingLiteral, .integerLiteral:
            tokens.append(CodeToken(range: start..<end, kind: .number))
        case let .identifier(name) where name.first?.isUppercase == true:
            tokens.append(CodeToken(range: start..<end, kind: .type))
        case .identifier where token.previousToken?.tokenKind == .funcKeyword:
            tokens.append(CodeToken(range: start..<end, kind: .funcName))
        default: ()
        }
        return Syntax(token)
    }
}
