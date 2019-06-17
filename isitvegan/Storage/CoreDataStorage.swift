import CoreData

class CoreDataStorage {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}

extension CoreDataStorage: StorageWriter {
    func writeItems(_ items: [Item]) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            for item in items {
                self.insertItem(item, context: context)
            }

            try! context.save()
        }
    }

    func deleteAllItems() {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            let fetchRequest = createFetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try! context.execute(batchDeleteRequest)
        }
    }
}

extension CoreDataStorage: StorageReader {
    func getAllItems() throws -> [Item] {
        let context = persistentContainer.viewContext
        return try fetchItems(createFetchRequest(), from: context)
    }

    func findItems(eNumber: String) throws -> [Item] {
        let context = persistentContainer.viewContext
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "eNumber BEGINSWITH[cd] %@", "e\(eNumber)")
        return try fetchItems(request, from: context)
    }

    func findItems(name: String) throws -> [Item] {
        let context = persistentContainer.viewContext
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        return try fetchItems(request, from: context)
    }
}

extension CoreDataStorage {
    private func insertItem(_ item: Item, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: itemEntityName, in: context)
        let managedItem = ItemManaged(entity: entity!, insertInto: context)
        managedItem.id = item.id
        managedItem.name = item.name
        managedItem.itemDescription = item.description
        managedItem.eNumber = item.eNumber
        managedItem.state = item.state.rawValue
    }
    
    private func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: itemEntityName)
    }
    
    private func fetchItems(_ request: NSFetchRequest<NSFetchRequestResult>,
                            from context: NSManagedObjectContext) throws -> [Item]  {
        let result = try context.fetch(request) as! [ItemManaged]
        return result.map { createItem(fromManaged: $0)! }
    }
    
    private func createItem(fromManaged managedItem: ItemManaged) -> Item? {
        Item(id: managedItem.id!,
             name: managedItem.name!,
             state: Item.State(rawValue: managedItem.state!)!,
             eNumber: managedItem.eNumber,
             description: managedItem.itemDescription!)
    }
}

fileprivate let itemEntityName = "Item"
