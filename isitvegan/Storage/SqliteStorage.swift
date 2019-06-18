import Foundation
import SQLite

class SqliteStorage {
    let connection: Connection
    
    private let items = VirtualTable("items")
    private let id = Expression<String>("id")
    private let name = Expression<String>("name")
    private let itemDescription = Expression<String>("description")
    private let eNumber = Expression<String?>("eNumber")
    private let state = Expression<String>("state")
    private let rank = Expression<Int64>("rank")
    
    init(connection: Connection) {
        self.connection = connection
    }
    
    func setupSchema() throws {
        let config = FTS5Config()
            .column(id, [.unindexed])
            .column(name)
            .column(itemDescription, [.unindexed])
            .column(eNumber, [.unindexed])
            .column(state, [.unindexed])
        try connection.run(items.drop(ifExists: true))
        try connection.run(items.create(.FTS5(config)))
    }
}

extension SqliteStorage: StorageReader {
    func getAllItems() throws -> [Item] {
        let itemRows = try connection.prepare(items.order(name))
        return itemRows.map { itemFrom(row: $0) }
    }

    func findItems(eNumber eNumberQuery: String) throws -> [Item] {
        let query = items.filter(eNumber.like("E\(eNumberQuery)%")).order(eNumber)
        let itemRows = try connection.prepare(query)
        return itemRows.map { itemFrom(row: $0) }
    }

    func findItems(name nameQuery: String) throws -> [Item] {
        let query = items.filter(name.match("\(nameQuery)*")).order(rank)
        let itemRows = try connection.prepare(query)
        return itemRows.map { itemFrom(row: $0) }
    }
}

extension SqliteStorage: StorageWriter {
    func writeItems(_ items: [Item]) {
        let dispatchGroup = DispatchGroup()
        
        try! connection.transaction {
            for item in items {
                let query = self.items.insert(
                    self.id <- item.id,
                    self.name <- item.name,
                    self.itemDescription <- item.description,
                    self.eNumber <- item.eNumber,
                    self.state <- item.state.rawValue
                )
                try! self.connection.run(query)
            }
        }
        
        dispatchGroup.wait()
    }
    
    func deleteAllItems() {
        try! connection.run(items.delete())
    }
}

extension SqliteStorage {
    private func itemFrom(row: Row) -> Item {
        Item(id: row[id],
             name: row[name],
             state: Item.State(rawValue: row[state])!,
             eNumber: row[eNumber],
             description: row[itemDescription])
    }
}
