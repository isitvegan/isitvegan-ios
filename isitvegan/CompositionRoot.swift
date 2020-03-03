import Foundation
import UIKit
import SQLite

class CompositionRoot {
    let sqliteStorage: SqliteStorage = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let connection = try! Connection("\(path)/database.sqlite3")
        return SqliteStorage(connection: connection)
    }()

    let quickActionEvent: QuickActionEvent = QuickActionEventImpl()

    func createRootView() -> RootViewController {
        let presenter = RootPresenterImpl()
        let controller = RootControllerImpl(presenter: presenter,
                                            conditionalStorageResetter: createConditionalStorageResetter())
        let view = RootViewController(controller: controller,
                                      createSearchView: createSearchView,
                                      createLoadingView: createLoadingView,
                                      createLoadingErrorView: createLoadingErrorView)

        presenter.view = view

        return view
    }

    private func createSearchView() -> SearchViewController {
        let searchPresenter = SearchPresenterImpl(createDetailView: createDetailView,
                                                  stateViewModelMapper: createStateViewModelMapper())
        let searchController = SearchControllerImpl(
            presenter: searchPresenter,
            itemsStorageUpdater: createItemsStorageUpdater(),
            storageReader: sqliteStorage
        )
        let searchView = SearchViewController(controller: searchController,
                                              cellClass: TableViewCell.self,
                                              quickActionEvent: quickActionEvent)
        searchPresenter.view = searchView
        return searchView
    }

    private func createLoadingView() -> LoadingViewController {
        return LoadingViewController()
    }

    private func createLoadingErrorView(_ retry: @escaping () -> Void) -> LoadingErrorViewController {
        return LoadingErrorViewController(retryLoading: retry)
    }

    private func createItemsStorageUpdater() -> ItemsStorageUpdater {
        return ItemsStorageUpdaterImpl(source: createItemsLoader(), target: sqliteStorage)
    }

    private func createDatabaseInitializationStateRepository() -> DatabaseInitializationStateRepository {
        DatabaseInitializationStateRepositoryImpl(userDefaults: UserDefaults.standard)
    }

    private func createDetailView(_ item: Item) -> DetailView {
        let presenter = DetailPresenterImpl(stateViewModelMapper: createStateViewModelMapper())
        let controller = DetailControllerImpl(presenter: presenter)
        let view = DetailViewController(controller: controller, item: item)
        presenter.view = view
        return view
    }

    private func createItemsLoader() -> ItemsLoader {
        NetworkItemsLoader(itemsDeserializer: JsonItemsDeserializer(decoder: JSONDecoder()))
    }

    private func createStateViewModelMapper() -> StateViewModelMapper {
        StateViewModelMapperImpl()
    }

    private func createConditionalStorageResetter() -> ConditionalStorageResetter {
        return ConditionalStorageResetterImpl(databaseInitializationStateRepository: createDatabaseInitializationStateRepository(),
                                              storageResetter: sqliteStorage,
                                              storageUpdater: createItemsStorageUpdater())
    }
}
