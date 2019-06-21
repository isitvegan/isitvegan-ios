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
        try connection.run(items.create(.FTS5(config), ifNotExists: true))
    }
}

extension SqliteStorage: StorageReader {
    func getAllItems(limit: Int) throws -> StorageReaderResult {
        let itemRows = try connection.prepare(items.order(name).limit(limit))
        let totalItemsWithoutLimit = try connection.scalar(items.select(id.count))
        let items = itemRows.map { itemFrom(row: $0) }
        return StorageReaderResult(items: items, totalItemsWithoutLimit: totalItemsWithoutLimit)
    }

    func findItems(eNumber eNumberQuery: String, limit: Int) throws -> StorageReaderResult {
        let escapedQuery = escapeLikeWildcard("E\(eNumberQuery)", escape: wildcardEscapeCharacter)
        let wildcard = eNumber.like("\(escapedQuery)%", escape: wildcardEscapeCharacter)
        let query = items.filter(wildcard).order(eNumber)
        let itemRows = try connection.prepare(query.limit(limit))
        let totalItemsWithoutLimit = try connection.scalar(query.select(id.count))
        let items = itemRows.map { itemFrom(row: $0) }
        return StorageReaderResult(items: items, totalItemsWithoutLimit: totalItemsWithoutLimit)
    }

    func findItems(name nameQuery: String, limit: Int) throws -> StorageReaderResult {
        let quotedQuery = quoteMatchString(nameQuery)
        let query = items.filter(name.match("\(quotedQuery)*")).order(rank)
        let itemRows = try connection.prepare(query.limit(limit))
        let totalItemsWithoutLimit = try connection.scalar(query.select(id.count))
        let items = itemRows.map { itemFrom(row: $0) }
        return StorageReaderResult(items: items, totalItemsWithoutLimit: totalItemsWithoutLimit)
    }
}

extension SqliteStorage: StorageWriter {
    func writeItems(_ items: [Item]) {
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

    private func escapeLikeWildcard(_ wildcard: String, escape: Character) -> String {
        wildcard.replacingOccurrences(of: "\(escape)", with: "\(escape)\(escape)")
                .replacingOccurrences(of: "%", with: "\(escape)%")
                .replacingOccurrences(of: "_", with: "\(escape)_")
    }

    private func quoteMatchString(_ string: String) -> String {
        let escaped = string.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
}

fileprivate let wildcardEscapeCharacter: Character = "\\"
