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
            storageReader: createCoreDataStorage()
        )
        let searchView = SearchViewController(controller: searchController)
        searchPresenter.view = searchView
        return searchView
    }
    
    private func createItemsStorageUpdater() -> ItemsStorageUpdater {
        let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        return ItemsStorageUpdaterImpl(source: itemsLoader, target: createCoreDataStorage())
    }
    
    private func createCoreDataStorage() -> CoreDataStorage {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = delegate.persistentContainer
        return CoreDataStorage(persistentContainer: persistentContainer)
    }
}
