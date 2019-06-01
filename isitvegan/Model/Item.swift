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
    
    init(fromManaged item: ItemManaged) {
        self.id = item.id!
        self.name = item.name!
        self.eNumber = item.eNumber
        self.state = State(rawValue: item.state!)!
        self.description = item.itemDescription!
    }
}
