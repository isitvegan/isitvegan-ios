protocol DetailPresenter {
    var view: DetailView! { get set }

    func present(item: Item)
}

class DetailPresenterImpl {
    var view: DetailView!
}

extension DetailPresenterImpl: DetailPresenter {
    func present(item: Item) {
        let description = item.description.replacingOccurrences(of: "\n", with: " ")
        let viewItem = DetailViewItem(name: item.name, description: description)
        view.show(item: viewItem)
    }
}
