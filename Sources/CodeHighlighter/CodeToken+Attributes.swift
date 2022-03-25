import Foundation
import Theme

extension CodeToken {
    func attributes(in block: (NSRange, String)) -> (range: NSRange, attributes: AttributeContainer) {
        let offset = block.0.location
        var range = NSRange(range, in: block.1)
        let color: ColorAsset = {
            switch kind {
            case .string: return Asset.string
            case .keyword: return Asset.keyword
            case .number: return Asset.number
            case .type: return Asset.type
            case .funcName: return Asset.functionName
            }
        }()
        range.location += offset - 2
        return (range, AttributeContainer([ .foregroundColor: color.color ]))
    }
}
