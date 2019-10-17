import Foundation

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
        DispatchQueue.global(qos: .userInitiated).async {
            let _ = item.sources.value()
            DispatchQueue.main.async {
                self.presenter.present(item: item)
            }
        }
    }
}
