protocol RootController {
    func run()
}

class RootControllerImpl {
    private let presenter: RootPresenter
    private let databaseInitializationStateRepository: DatabaseInitializationStateRepository
    private let itemsStorageUpdater: ItemsStorageUpdater

    init(presenter: RootPresenter,
         databaseInitializationStateRepository: DatabaseInitializationStateRepository,
         itemsStorageUpdater: ItemsStorageUpdater) {
        self.presenter = presenter
        self.databaseInitializationStateRepository = databaseInitializationStateRepository
        self.itemsStorageUpdater = itemsStorageUpdater
    }
}

extension RootControllerImpl: RootController {
    func run() {
        let databaseInitializationState = databaseInitializationStateRepository.read()
        switch databaseInitializationState {
        case .initialized:
            presenter.presentSearchView()
        case .uninitialized:
            populateDatabase()
        }
    }
}

extension RootControllerImpl {
    private func populateDatabase() {
        presenter.presentLoadingView()

        itemsStorageUpdater.updateItems { result in
            switch result {
            case .success(_):
                self.databaseInitializationStateRepository.write(value: .initialized)
                self.presenter.presentSearchView()
            case .failure(_):
                self.presenter.presentLoadingErrorView(retry: { self.run() })
            }
        }
    }
}
