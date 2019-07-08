import UIKit
import SQLite
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var compositionRoot: CompositionRoot = CompositionRoot()

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // TODO: only do this on the first launch
        // populateDatabase()
        try! compositionRoot.sqliteStorage.setupSchema()
    }

    private func populateDatabase() {
        // let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        // let storageWriter = CoreDataStorage(persistentContainer: persistentContainer)
        // let itemsStorageUpdater = ItemsStorageUpdaterImpl(source: itemsLoader, target: storageWriter)
        // itemsStorageUpdater.updateItems(completion: {})
    }

}

