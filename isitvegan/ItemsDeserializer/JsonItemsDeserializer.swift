import Foundation

class JsonItemsDeserializer {
    private var decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
}

extension JsonItemsDeserializer: ItemsDeserializer {
    func deserializeItems(from data: Data) -> Result<[Item], Error> {
        return Result {
            try decoder.decode([JsonItem].self, from: data).map { $0.item }
        }
    }
}

fileprivate struct JsonItem {
    let item: Item
}

extension JsonItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case alternativeNames = "alternative_names"
        case state
        case eNumber = "e_number"
        case description
        case sources
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        let alternativeNames = try values.decode([String].self, forKey: .alternativeNames)
        let state = try values.decode(JsonItemState.self, forKey: .state).state
        let eNumber = try values.decodeIfPresent(String.self, forKey: .eNumber)
        let description = try values.decode(String.self, forKey: .description)
        let sources = try values.decode([JsonItemSource].self, forKey: .sources).map { $0.source }
        item = Item(name: name, alternativeNames: alternativeNames,
                    state: state, eNumber: eNumber,
                    description: description, sources: LazyValue { sources })
    }
}

fileprivate struct JsonItemState {
    let state: Item.State
}

extension JsonItemState: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch (value) {
        case "vegan":
            state = .vegan
        case "carnist":
            state = .carnist
        case "itDepends":
            state = .itDepends
        default:
            throw ItemStateDecodeError.InvalidVariant(value)
        }
    }
}

enum ItemStateDecodeError: Error {
    case InvalidVariant(String)
}

fileprivate struct JsonItemSource {
    let source: Item.Source
}

extension JsonItemSource: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case value
        case lastChecked = "last_checked"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(JsonItemSourceType.self, forKey: .type)
        let value = try values.decode(String.self, forKey: .value)
        let lastCheckedString = try values.decodeIfPresent(String.self, forKey: .lastChecked)
        let lastChecked = lastCheckedString.flatMap(Self.isoDate)
        source = Item.Source(type: type.sourceType,
                             value: value,
                             lastChecked: lastChecked)
    }

    private static func isoDate(from: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: from)
    }
}

fileprivate struct JsonItemSourceType {
    let sourceType: Item.Source.SourceType
}

extension JsonItemSourceType: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "url":
            sourceType = .url
        default:
            throw ItemSourceDecodeError.InvalidType(value)
        }
    }
}

enum ItemSourceDecodeError: Error {
    case InvalidType(String)
}
