struct StorageReaderResult {
    let items: [Item]
    let totalItemsWithoutLimit: Int
}

protocol StorageReader {
    func getAllItems(limit: Int) throws -> StorageReaderResult
    
    /// Finds items by their E number.
    /// - Parameters:
    ///   - eNumber: An E number with or without leading "E"
    func findItems(eNumber: String, limit: Int) throws -> StorageReaderResult

    /// Finds items by their name or one of their alternative names.
    func findItems(name: String, limit: Int) throws -> StorageReaderResult
}
