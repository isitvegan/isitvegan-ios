import UIKit
import CoreData
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = createPersistentContainer()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let indexer = SpotlightIndexerImpl(searchableIndex: CSSearchableIndex.default())
        let itemsLoader = DummyItemsLoader(itemsDeserializer: JsonItemDeserializer(decoder: JSONDecoder()))

        indexer.deleteAll()
        indexer.index(items: itemsLoader.loadItems())
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
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

