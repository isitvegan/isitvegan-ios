import Foundation

protocol SearchController {
    func listItems()

    func search(name: String)

    func search(eNumber: String)

    func refreshItems(_ completion: @escaping (_ result: Result<Void, Error>) -> Void)

    func showDetail(itemIndex: Int)
}

class SearchControllerImpl {
    private var presenter: SearchPresenter
    private let itemsStorageUpdater: ItemsStorageUpdater
    private let storageReader: StorageReader
    private var filter: Filter = .none
    private var items: [Item]?

    init(presenter: SearchPresenter,
         itemsStorageUpdater: ItemsStorageUpdater,
         storageReader: StorageReader) {
        self.presenter = presenter
        self.itemsStorageUpdater = itemsStorageUpdater
        self.storageReader = storageReader

        self.presenter.itemByIndex = { index in
            self.items![index]
        }
    }
}

extension SearchControllerImpl: SearchController {
    func showDetail(itemIndex: Int) {
        let item = items![itemIndex]
        presenter.presentDetail(item: item)
    }

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

    func refreshItems(_ completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        itemsStorageUpdater.updateItems(completion: { result in
            completion(result.map { _ in self.presentItems() })
        })
    }
}

extension SearchControllerImpl {
    private func updateFilter(newFilter: Filter) {
        if newFilter != filter || items == nil {
            filter = newFilter
            presentItems()
        }
    }

    private func presentItems() {
        let result = fetchItems()
        items = result.items
        presenter.present(items: result.items)
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
