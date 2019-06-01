import UIKit
import CoreData
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = createPersistentContainer()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let indexer = SpotlightIndexerImpl(searchableIndex: CSSearchableIndex.default())
        let items: [Item] = [
            Item(id: "oat-milk",
                 name: "Oat Milk",
                 state: .vegan,
                 eNumber: nil,
                 description: """
Oat milk is a type of plant milk derived from whole oat grains by soaking the plant material to extract its nutrients. Oat milk naturally has a creamy texture and a characteristically oatmeal-like flavor, though it is sold commercially in various flavor-varieties such as sweetened, unsweetened, vanilla, and chocolate. Unlike other plant milks, whose origins date as early as the 13th century, oat milk is a modern creation, developed by the Swedish scientist Rickard Oste in the early 1990s, who went on to found Oatly, the first commercial manufacturer of oat milk.
"""),
            Item(id: "milk",
                 name: "Milk",
                 state: .carnist,
                 eNumber: nil,
                 description: """
Given the chance, cows nurture their young and form lifelong friendships with one another. They play games and have a wide range of emotions and personality traits. But most cows raised for the dairy industry are intensively confined, leaving them unable to fulfill their most basic desires, such as nursing their calves, even for a single day. They are treated like milk-producing machines and are genetically manipulated and may be pumped full of antibiotics and hormones in order to produce more milk. While cows suffer on factory farms, humans who drink their milk increase their chances of developing heart disease, diabetes, cancer, and many other ailments.
""")
        ]
        
        indexer.deleteAll()
        indexer.index(items: items)
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

