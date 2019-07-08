import Foundation
import UIKit
import CoreData

class DefaultSceneDelegate: UIResponder {
    var window: UIWindow?
}

extension DefaultSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = createSearchView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()
    }
}

extension DefaultSceneDelegate {
    private func createSearchView() -> SearchViewController {
        let searchPresenter = SearchPresenterImpl(createDetailView: createDetailView,
                                                  stateViewModelMapper: createStateViewModelMapper())
        let searchController = SearchControllerImpl(
            presenter: searchPresenter,
            itemsStorageUpdater: createItemsStorageUpdater(),
            storageReader: getSqliteStorage()
        )
        let searchView = SearchViewController(controller: searchController,
                                              cellClass: TableViewCell.self)
        searchPresenter.view = searchView
        return searchView
    }
    
    private func createDetailView(_ item: Item) -> DetailView {
        let presenter = DetailPresenterImpl()
        let controller = DetailControllerImpl(presenter: presenter)
        let view = DetailViewController(controller: controller, item: item)
        presenter.view = view
        return view
    }

    private func createItemsStorageUpdater() -> ItemsStorageUpdater {
        return ItemsStorageUpdaterImpl(source: createItemsLoader(), target: getSqliteStorage())
    }

    private func createItemsLoader() -> ItemsLoader {
        NetworkItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
    }
    
    private func getSqliteStorage() -> SqliteStorage {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.storage
    }

    private func createStateViewModelMapper() -> StateViewModelMapper {
        StateViewModelMapperImpl()
    }
}
