protocol DetailPresenter {
    var view: DetailView! { get set }

    func present(item: Item)
}

class DetailPresenterImpl {
    var view: DetailView!
}

extension DetailPresenterImpl: DetailPresenter {
    func present(item: Item) {
        let viewItem = DetailViewItem(name: item.name, description: item.description)
        view.show(item: viewItem)
    }
}
