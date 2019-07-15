import UIKit
import SQLite
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var compositionRoot: CompositionRoot = CompositionRoot()
    var window: UIWindow?

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = compositionRoot.createSearchView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()
        return true
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

