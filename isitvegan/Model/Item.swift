struct Item {
    enum State: String {
        case vegan = "vegan"
        case carnist = "carnist"
        case itDepends = "itDepends"
    }

    enum Source {
        case url(String)
    }

    let id: String
    let name: String
    let state: State
    let eNumber: String?
    let description: String
    let sources: [Source]
}
