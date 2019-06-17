protocol StorageWriter {
    func writeItems(_ items: [Item])

    func deleteAllItems()
}

