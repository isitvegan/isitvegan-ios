import Foundation
import UIKit
import SQLite

class CompositionRoot {
    let sqliteStorage: SqliteStorage = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let connection = try! Connection("\(path)/database.sqlite3")
        return SqliteStorage(connection: connection)
    }()

    func createRootView() -> RootViewController {
        let presenter = RootPresenterImpl()
        let controller = RootControllerImpl(presenter: presenter,
                                            databaseInitializationStateRepository: createDatabaseInitializationStateRepository(),
                                            itemsStorageUpdater: createItemsStorageUpdater())
        let view = RootViewController(controller: controller, createSearchView: createSearchView, createLoadingView: createLoadingView)

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
                                              cellClass: TableViewCell.self)
        searchPresenter.view = searchView
        return searchView
    }

    private func createLoadingView() -> LoadingViewController {
        return LoadingViewController()
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
}
