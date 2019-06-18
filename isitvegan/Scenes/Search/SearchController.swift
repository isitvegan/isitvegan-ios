protocol SearchController {
    func listItems()
    
    func search(name: String)
    
    func search(eNumber: String)
    
    func refreshItems(completion: @escaping () -> Void)
}

class SearchControllerImpl {
    private let presenter: SearchPresenter
    private let itemsStorageUpdater: ItemsStorageUpdater
    private let storageReader: StorageReader
    private var filter: Filter = .none

    init(presenter: SearchPresenter,
         itemsStorageUpdater: ItemsStorageUpdater,
         storageReader: StorageReader) {
        self.presenter = presenter
        self.itemsStorageUpdater = itemsStorageUpdater
        self.storageReader = storageReader
    }
}

extension SearchControllerImpl: SearchController {
    func listItems() {
        filter = .none
        presentItems()
    }
    
    func search(name: String) {
        if (name.isEmpty) {
            filter = .none
        } else {
            filter = .name(name)
        }
        presentItems()
    }

    func search(eNumber: String) {
        if (eNumber.isEmpty) {
            filter = .none
        } else {
            filter = .eNumber(eNumber)
        }
        presentItems()
    }
    
    func refreshItems(completion: @escaping () -> Void) {
        itemsStorageUpdater.updateItems(completion: {
            self.presentItems()
            completion()
        })
    }
}

extension SearchControllerImpl {
    private func presentItems() {
        presenter.present(items: fetchItems())
    }
        
    private func fetchItems() -> [Item] {
        switch (filter) {
        case .none:
            return try! storageReader.getAllItems()
        case .name(let name):
            return try! storageReader.findItems(name: name)
        case .eNumber(let eNumber):
            return try! storageReader.findItems(eNumber: eNumber)
        }
    }
    
    private enum Filter {
        case none
        case name(String)
        case eNumber(String)
    }
}
