struct Item {
    enum State: String {
        case vegan = "vegan"
        case carnist = "carnist"
        case itDepends = "itDepends"
    }
    
    let id: String
    let name: String
    let state: State
    let eNumber: String?
    let description: String
    
    init(id: String, name: String, state: State, eNumber: String?, description: String) {
        self.id = id
        self.name = name
        self.state = state
        self.eNumber = eNumber
        self.description = description
    }
}

extension Item.State: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch (value) {
        case "vegan":
            self = .vegan
        case "carnist":
            self = .carnist
        case "it_depends":
            self = .itDepends
        default:
            throw ItemStateDecodeError.InvalidVariant(value)
        }
    }
}

enum ItemStateDecodeError: Error {
    case InvalidVariant(String)
}

extension Item: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case state
        case eNumber = "e_number"
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        state = try values.decode(Item.State.self, forKey: .state)
        eNumber = try values.decodeIfPresent(String.self, forKey: .eNumber)
        description = try values.decode(String.self, forKey: .description)
    }
}
