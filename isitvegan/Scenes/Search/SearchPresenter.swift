import UIKit

protocol SearchPresenter {
    var view: SearchView! { get set }
    
    func present(items: [Item], totalItemsWithoutLimit: Int)

    func presentDetail(item: Item)
}

class SearchPresenterImpl {
    private let createDetailView: (_ item: Item) -> DetailView
    var view: SearchView!
    
    init(createDetailView: @escaping (_ item: Item) -> DetailView) {
        self.createDetailView = createDetailView
    }
}

extension SearchPresenterImpl: SearchPresenter {
    func present(items: [Item], totalItemsWithoutLimit: Int) {
        let viewItems = items.map(createSearchViewItem)
        let itemsNotShownDueToLimit = totalItemsWithoutLimit - items.count
        view.listItems(items: viewItems, itemsNotShownDueToLimit: itemsNotShownDueToLimit)
    }

    func presentDetail(item: Item) {
        let detailView = createDetailView(item)
        view.showDetailView(detailView.asUIViewController())
    }
}

extension SearchPresenterImpl {
    private func createSearchViewItem(item: Item) -> SearchViewItem {
        let stateTitle = titleFor(state: item.state)
        return SearchViewItem(name: item.name,
                              eNumber: item.eNumber ?? "",
                              stateDescription: stateTitle,
                              stateImageName: imageFor(state: item.state),
                              stateColor: colorFor(state: item.state))
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

    private func imageFor(state: Item.State) -> String {
        switch (state) {
        case .vegan:
            return "checkmark.circle.fill"
        case .carnist:
            return "xmark.circle.fill"
        case .itDepends:
            return "questionmark.circle.fill"
        }
    }

    private func colorFor(state: Item.State) -> UIColor {
        switch (state) {
        case .vegan:
            return .veganGreen
        case .carnist:
            return .systemRed
        case .itDepends:
            return .secondaryLabel
        }
    }
}
