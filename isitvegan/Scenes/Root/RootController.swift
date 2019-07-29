protocol RootController {
    func run()
}

class RootControllerImpl {
    private let presenter: RootPresenter
    private let conditionalStorageResetter: ConditionalStorageResetter

    init(presenter: RootPresenter,
         conditionalStorageResetter: ConditionalStorageResetter) {
        self.presenter = presenter
        self.conditionalStorageResetter = conditionalStorageResetter
    }
}

extension RootControllerImpl: RootController {
    func run() {
        presenter.presentLoadingView()

        conditionalStorageResetter.resetStorageIfNeeded { result in
            switch result {
            case .success(_):
                self.presenter.presentSearchView()
            case .failure(_):
                self.presenter.presentLoadingErrorView(retry: { self.run() })
            }
        }
    }
}
