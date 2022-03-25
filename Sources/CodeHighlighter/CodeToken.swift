import Foundation

public struct CodeToken {
    public let range: Range<String.Index>
    public let kind: Kind
    
    public enum Kind: String {
        case string
        case keyword
        case number
        case type
        case funcName
    }
}
