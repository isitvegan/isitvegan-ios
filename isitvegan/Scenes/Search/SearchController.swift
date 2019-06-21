import Foundation

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
    private var itemsPresentedAtLeastOnce: Bool = false

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
        updateFilter(newFilter: .none)
    }

    func search(name: String) {
        updateFilter(newFilter: name.isEmpty ? .none : .name(name))
    }

    func search(eNumber: String) {
        let normalizedENumber = normalizeENumber(eNumber)
        updateFilter(newFilter: normalizedENumber.isEmpty ? .none : .eNumber(normalizedENumber))
    }

    func refreshItems(completion: @escaping () -> Void) {
        itemsStorageUpdater.updateItems(completion: {
            self.presentItems()
            completion()
        })
    }
}

extension SearchControllerImpl {
    private func updateFilter(newFilter: Filter) {
        if newFilter != filter || !itemsPresentedAtLeastOnce {
            filter = newFilter
            presentItems()
        }
    }

    private func presentItems() {
        self.itemsPresentedAtLeastOnce = true
        let result = fetchItems()
        presenter.present(items: result.items, totalItemsWithoutLimit: result.totalItemsWithoutLimit)
    }
        
    private func fetchItems() -> StorageReaderResult {
        switch (filter) {
        case .none:
            return try! storageReader.getAllItems(limit: maxItemsToBeShown)
        case .name(let name):
            return try! storageReader.findItems(name: name, limit: maxItemsToBeShown)
        case .eNumber(let eNumber):
            return try! storageReader.findItems(eNumber: eNumber, limit: maxItemsToBeShown)
        }
    }
    
    private func normalizeENumber(_ eNumber: String) -> String {
        let trimCharacterSet = CharacterSet(charactersIn: "E").union(.whitespaces)
        return eNumber.trimmingCharacters(in: trimCharacterSet)
    }

    private enum Filter: Equatable {
        case none
        case name(String)
        case eNumber(String)
    }
}

fileprivate let maxItemsToBeShown = 50
