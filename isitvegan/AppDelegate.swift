import UIKit
import SQLite
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var storage: SqliteStorage = createSqliteStorage()
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // try! storage.setupSchema()
        // TODO: only do this on the first launch
        // populateDatabase()
    }

    private func populateDatabase() {
        // let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        // let storageWriter = CoreDataStorage(persistentContainer: persistentContainer)
        // let itemsStorageUpdater = ItemsStorageUpdaterImpl(source: itemsLoader, target: storageWriter)
        // itemsStorageUpdater.updateItems(completion: {})
    }
    
    private func createSqliteStorage() -> SqliteStorage {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let connection = try! Connection("\(path)/database.sqlite3")
        return SqliteStorage(connection: connection)
    }
}

