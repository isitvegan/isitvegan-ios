class ItemsStorageUpdaterImpl {
    private let itemsLoader: ItemsLoader
    private let storageWriter: StorageWriter
    
    init(source itemsLoader: ItemsLoader, target storageWriter: StorageWriter) {
        self.itemsLoader = itemsLoader
        self.storageWriter = storageWriter
    }
}

extension ItemsStorageUpdaterImpl: ItemsStorageUpdater {
    func updateItems() {
        let items = itemsLoader.loadItems()
        storageWriter.deleteAllItems()
        storageWriter.writeItems(items)
    }
}
