import Foundation

struct Item {
    enum State: String {
        case vegan = "vegan"
        case carnist = "carnist"
        case itDepends = "itDepends"
    }

    struct Source {
        enum SourceType: String {
            case url = "url"
        }

        let type: SourceType
        let value: String
        let lastChecked: Date?
    }

    let name: String
    let alternativeNames: [String]
    let state: State
    let eNumber: String?
    let description: String
    let sources: [Source]
}
