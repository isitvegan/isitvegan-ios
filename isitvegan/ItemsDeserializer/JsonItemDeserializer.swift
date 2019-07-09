import Foundation

class JsonItemDeserializer {
    private var decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
}

extension JsonItemDeserializer: ItemsDeserializer {
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
        case id = "slug"
        case name
        case state
        case eNumber = "e_number"
        case description
        case sources
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(String.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let state = try values.decode(JsonItemState.self, forKey: .state).state
        let eNumber = try values.decodeIfPresent(String.self, forKey: .eNumber)
        let description = try values.decode(String.self, forKey: .description)
        let sources = try values.decode([JsonItemSource].self, forKey: .sources).map { $0.source }
        item = Item(id: id, name: name, state: state, eNumber: eNumber, description: description, sources: sources)
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
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(String.self, forKey: .type)
        let value = try values.decode(String.self, forKey: .value)
        switch (type) {
        case "url":
            source = .url(value)
        default:
            throw ItemSourceDecodeError.InvalidType(type)
        }
    }
}

enum ItemSourceDecodeError: Error {
    case InvalidType(String)
}
