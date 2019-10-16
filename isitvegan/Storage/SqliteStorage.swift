import Foundation
import SQLite
import enum Swift.Result

class SqliteStorage {
    let databaseVersion = DatabaseVersion(4)

    private let connection: Connection

    private let items = Table("items")
    private let names = VirtualTable("names")
    private let sources = Table("sources")

    init(connection: Connection) {
        self.connection = connection
    }

    private func createNamesTable() throws {
        let config = FTS5Config()
            .column(Names.name)
            .column(Names.item, [.unindexed])
        try connection.run(names.create(.FTS5(config), ifNotExists: true))
    }

    private func createItemsTable() throws {
        try connection.run(items.create(ifNotExists: true) { t in
            t.column(Items.id, primaryKey: .autoincrement)
            t.column(Items.name)
            t.column(Items.itemDescription)
            t.column(Items.eNumber)
            t.column(Items.state)
        })
    }

    private func createSourcesTable() throws {
        try connection.run(sources.create(ifNotExists: true) { t in
            t.column(Sources.id, primaryKey: .autoincrement)
            t.column(Sources.item, references: items, Items.id)
            t.column(Sources.type)
            t.column(Sources.value)
            t.column(Sources.lastChecked)
        })
    }
}

extension SqliteStorage {
    private class Sources {
        static let id = Expression<Int64>("id")
        static let item = Expression<Int64>("item")
        static let type = Expression<String>("type")
        static let value = Expression<String>("value")
        static let lastChecked = Expression<Date?>("lastChecked")
    }

    private class Items {
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        static let itemDescription = Expression<String>("description")
        static let eNumber = Expression<String?>("eNumber")
        static let state = Expression<String>("state")
    }

    private class Names {
        static let name = Expression<String>("name")
        static let item = Expression<Int64>("item")
        static let rank = Expression<Int64>("rank")
    }
}

extension SqliteStorage: StorageReader {
    func getAllItems(limit: Int) throws -> StorageReaderResult {
        return try findItemsBy(query: items.order(Items.name), limit: limit)
    }

    func findItems(eNumber eNumberQuery: String, limit: Int) throws -> StorageReaderResult {
        let escapedQuery = escapeLikeWildcard("E\(eNumberQuery)", escape: wildcardEscapeCharacter)
        let wildcard = Items.eNumber.like("\(escapedQuery)%", escape: wildcardEscapeCharacter)
        let query = items.filter(wildcard).order(Items.eNumber)
        return try findItemsBy(query: query, limit: limit)
    }

    func findItems(name nameQuery: String, limit: Int) throws -> StorageReaderResult {
        let quotedQuery = quoteMatchString(nameQuery)
        let query = items.select(items[*])
                         .join(names, on: names[Names.item] == items[Items.id])
                         .filter(names[Names.name].match("\(quotedQuery)*"))
                         .order(names[Names.rank])
                         .group(items[Items.id])
        return try findItemsBy(query: query, limit: limit)
    }
}

extension SqliteStorage: StorageWriter {
    func writeItems(_ items: [Item]) -> Result<Void, Error> {
        return Result {
            try connection.transaction {
                for item in items {
                    let itemId = try writeItem(item)
                    try writeItemNames(itemId: itemId, item: item)
                    try writeItemSources(itemId: itemId, item: item)
                }
            }
        }
    }

    func deleteAllItems() -> Result<Void, Error> {
        return Result {
            try connection.transaction {
                try connection.run(items.delete())
                try connection.run(names.delete())
                try connection.run(sources.delete())
            }
        }
    }
}

extension SqliteStorage: StorageResetter {
    func resetStorage() -> Result<Void, Error> {
        return Result {
            try connection.execute("""
PRAGMA writable_schema = 1;
DELETE FROM sqlite_master WHERE type = 'table';
PRAGMA writable_schema = 0;
VACUUM;
""")
        }
    }

    func initializeStorage() -> Result<Void, Error> {
        return Result {
            try connection.transaction {
                try createItemsTable()
                try createNamesTable()
                try createSourcesTable()
            }
        }
    }
}

extension SqliteStorage {
    private func writeItem(_ item: Item) throws -> Int64  {
        let query = items.insert(
            Items.name <- item.name,
            Items.itemDescription <- item.description,
            Items.eNumber <- item.eNumber,
            Items.state <- item.state.rawValue
        )
        try connection.run(query)
        return connection.lastInsertRowid
    }

    private func writeItemNames(itemId: Int64, item: Item) throws {
        try writeItemName(itemId: itemId, name: item.name)
        for name in item.alternativeNames {
            try writeItemName(itemId: itemId, name: name)
        }
    }

    private func writeItemName(itemId: Int64, name: String) throws {
        try connection.run(names.insert(
            Names.item <- itemId,
            Names.name <- name
        ))
    }

    private func writeItemSources(itemId: Int64, item: Item) throws {
        for source in item.sources.value() {
            try writeItemSource(itemId: itemId, source: source)
        }
    }

    private func writeItemSource(itemId: Int64, source: Item.Source) throws {
        try connection.run(sources.insert(
            Sources.item <- itemId,
            Sources.type <- source.type.rawValue,
            Sources.value <- source.value,
            Sources.lastChecked <- source.lastChecked
        ))
    }

    private func findItemsBy(query: SchemaType, limit: Int) throws -> StorageReaderResult {
        let itemRows = try connection.prepare(query.limit(limit)).map { $0 }
        let items = try itemRows.map { try itemFrom(row: $0) }
        return StorageReaderResult(items: items)
    }

    private func itemFrom(row: Row) throws -> Item {
        let sources = LazyValue {
            try! self.findItemSources(itemId: row[Items.id])
        }

        return Item(name: row[Items.name],
                    alternativeNames: [],
                    state: Item.State(rawValue: row[Items.state])!,
                    eNumber: row[Items.eNumber],
                    description: row[Items.itemDescription],
                    sources: sources)
    }

    private func findItemSources(itemId: Int64) throws -> [Item.Source] {
        let rows = try connection.prepare(sources.filter(Sources.item == itemId))
        return rows.map { itemSourceFrom(row: $0) }
    }

    private func itemSourceFrom(row: Row) -> Item.Source {
        return Item.Source(type: Item.Source.SourceType(rawValue: row[Sources.type])!,
                           value: row[Sources.value],
                           lastChecked: row[Sources.lastChecked])
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
