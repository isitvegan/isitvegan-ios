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
        let searchPresenter = SearchPresenterImpl()
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
    
    private func createItemsStorageUpdater() -> ItemsStorageUpdater {
        let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        return ItemsStorageUpdaterImpl(source: itemsLoader, target: getSqliteStorage())
    }
    
    private func getSqliteStorage() -> SqliteStorage {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.storage
    }
}
