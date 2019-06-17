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
        let viewItems = items.map { SearchViewItem(name: $0.name) }
        self.view.listItems(items: viewItems)
    }

    func present(item: Item) {
    }
}
