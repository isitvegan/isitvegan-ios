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
    func updateItems(completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.itemsLoader.loadItems(completion: { items in
                let result = items.flatMap(self.writeItems)
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }

    private func writeItems(_ items: [Item]) -> Result<Void, Error> {
        return storageWriter.deleteAllItems()
            .flatMap { _ in storageWriter.writeItems(items) }
    }
}
