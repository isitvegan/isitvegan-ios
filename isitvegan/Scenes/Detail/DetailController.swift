protocol DetailController {
    func show(item: Item)
}

class DetailControllerImpl {
    private let presenter: DetailPresenter

    init(presenter: DetailPresenter) {
        self.presenter = presenter
    }
}

extension DetailControllerImpl: DetailController {
    func show(item: Item) {
        presenter.present(item: item)
    }
}
