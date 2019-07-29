import UIKit

protocol SearchPresenter {
    var view: SearchView! { get set }
    var itemByIndex: ((_ itemIndex: Int) -> Item)! { get set }
    
    func present(items: [Item])

    func presentDetail(item: Item)
}

class SearchPresenterImpl {
    var view: SearchView!
    var itemByIndex: ((_ index: Int) -> Item)!

    private let createDetailView: (_ item: Item) -> DetailView
    private let stateViewModelMapper: StateViewModelMapper

    init(createDetailView: @escaping (_ item: Item) -> DetailView,
         stateViewModelMapper: StateViewModelMapper) {
        self.createDetailView = createDetailView
        self.stateViewModelMapper = stateViewModelMapper
    }
}

extension SearchPresenterImpl: SearchPresenter {
    func present(items: [Item]) {
        let viewItems = items.map(createSearchViewItem)
        view?.listItems(items: viewItems,
                        createItemPreviewView: createItemPreviewView)
    }

    func presentDetail(item: Item) {
        let detailView = createDetailView(item)
        view?.showDetailView(detailView.asUIViewController())
    }
}

extension SearchPresenterImpl {
    private func createSearchViewItem(item: Item) -> SearchViewItem {
        return SearchViewItem(name: item.name,
                              eNumber: item.eNumber ?? "",
                              state: stateViewModelMapper.stateToViewModel(item.state))
    }

    private func createItemPreviewView(_ itemIndex: Int) -> UIViewController {
        createDetailView(itemByIndex(itemIndex)).asUIViewController()
    }
}
