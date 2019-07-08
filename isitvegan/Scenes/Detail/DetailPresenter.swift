protocol DetailPresenter {
    var view: DetailView! { get set }

    func present(item: Item)
}

class DetailPresenterImpl {
    var view: DetailView!

    private let stateViewModelMapper: StateViewModelMapper

    init(stateViewModelMapper: StateViewModelMapper) {
        self.stateViewModelMapper = stateViewModelMapper
    }
}

extension DetailPresenterImpl: DetailPresenter {
    func present(item: Item) {
        let description = item.description.replacingOccurrences(of: "\n", with: " ")
        let state = stateViewModelMapper.stateToViewModel(item.state)
        let viewItem = DetailViewItem(name: item.name, description: description, state: state)
        view.show(item: viewItem)
    }
}
