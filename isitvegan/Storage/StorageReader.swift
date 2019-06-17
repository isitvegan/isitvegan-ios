protocol StorageReader {
    func getAllItems() throws -> [Item]
    
    /// Finds items by their E number.
    /// - Parameters:
    ///   - eNumber: An E number with or without leading "E"
    func findItems(eNumber: String) throws -> [Item]

    /// Finds items by their name or one of their alternative names.
    func findItems(name: String) throws -> [Item]
}
