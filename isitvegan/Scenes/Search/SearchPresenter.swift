protocol SearchPresenter {
    var view: SearchView! { get set }
    
    func present(items: [Item])

    func present(item: Item)
}

class SearchPresenterImpl {
    var view: SearchView!
}

extension SearchPresenterImpl: SearchPresenter {
    func present(items: [Item]) {
        let viewItems = items.map(createSearchViewItem)
        self.view.listItems(items: viewItems)
    }

    func present(item: Item) {
    }
}

extension SearchPresenterImpl {
    private func createSearchViewItem(item: Item) -> SearchViewItem {
        return SearchViewItem(name: item.name,
                              eNumber: item.eNumber ?? "")
    }
}
