import Foundation
import UIKit

class DefaultSceneDelegate: UIResponder {
    var window: UIWindow?
}

extension DefaultSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        let (searchController, searchView) = createSearchController()
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window!.rootViewController = searchView
        window!.makeKeyAndVisible()
        
        searchController.listItems()
    }
}

extension DefaultSceneDelegate {
    private func createSearchController() -> (SearchController, SearchViewController) {
        let searchPresenter = SearchPresenterImpl()
        let searchController = SearchControllerImpl(
            presenter: searchPresenter,
            itemsStorageUpdater: createItemsStorageUpdater(),
            storageReader: createCoreDataStorage()
        )
        let searchView = SearchViewController(controller: searchController)
        searchPresenter.view = searchView
        return (searchController, searchView)
    }
    
    private func createItemsStorageUpdater() -> ItemsStorageUpdater {
        let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        return ItemsStorageUpdaterImpl(source: itemsLoader, target: createCoreDataStorage())
    }
    
    private func createCoreDataStorage() -> CoreDataStorage {
        CoreDataStorage(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
    }
}
