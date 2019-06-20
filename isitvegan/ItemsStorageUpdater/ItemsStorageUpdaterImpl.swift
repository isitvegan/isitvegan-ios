import Foundation

class ItemsStorageUpdaterImpl {
    private let itemsLoader: ItemsLoader
    private let storageWriter: StorageWriter
    
    init(source itemsLoader: ItemsLoader, target storageWriter: StorageWriter) {
        self.itemsLoader = itemsLoader
        self.storageWriter = storageWriter
    }
}

extension ItemsStorageUpdaterImpl: ItemsStorageUpdater {
    func updateItems(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.itemsLoader.loadItems(completion: { items in
                self.storageWriter.deleteAllItems()
                self.storageWriter.writeItems(items)
                DispatchQueue.main.async {
                    completion()
                }
            })
        }
    }
}
