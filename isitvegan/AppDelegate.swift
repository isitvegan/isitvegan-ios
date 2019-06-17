import UIKit
import CoreData
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = createPersistentContainer()
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // TODO: only do this on the first launch
        populateDatabase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    private func populateDatabase() {
        let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))
        let storageWriter = CoreDataStorage(persistentContainer: persistentContainer)
        let itemsStorageUpdater = ItemsStorageUpdaterImpl(source: itemsLoader, target: storageWriter)
        itemsStorageUpdater.updateItems()
        storageWriter.deleteAllItems()
    }
    
    private func createPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

