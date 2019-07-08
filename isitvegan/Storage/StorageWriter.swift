protocol StorageWriter {
    func writeItems(_ items: [Item]) -> Result<Void, Error>

    func deleteAllItems() -> Result<Void, Error>
}

