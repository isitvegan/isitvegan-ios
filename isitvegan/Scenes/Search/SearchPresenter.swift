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
        let stateTitle = titleFor(state: item.state)
        return SearchViewItem(name: "\(item.name) · \(stateTitle)",
                              eNumber: item.eNumber ?? "")
    }

    private func titleFor(state: Item.State) -> String {
        switch (state) {
        case .vegan:
            return "Vegan"
        case .carnist:
            return "Carnist"
        case .itDepends:
            return "It Depends"
        }
    }
}
