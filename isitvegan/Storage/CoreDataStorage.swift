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
            try! context.save()
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
        let eNumber = normalizeENumber(eNumber)
        request.predicate = NSPredicate(format: "eNumber BEGINSWITH[cd] %@", "\(eNumber)")
        request.sortDescriptors = [
            NSSortDescriptor(key: "eNumber", ascending: true)
        ]
        return try fetchItems(request, from: context)
    }

    func findItems(name: String) throws -> [Item] {
        let context = persistentContainer.viewContext
        let request = createFetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        let items = try fetchItems(request, from: context)
        return items.map { ($0, $0.name.lowercased().range(of: name.lowercased())?.lowerBound ?? String.Index(encodedOffset: 1000)) }
            .sorted(by: { $0.1 < $1.1 })
            .map({ $0.0 })
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

    private func normalizeENumber(_ eNumber: String) -> String {
        let trimCharacterSet = CharacterSet(charactersIn: "E").union(.whitespaces)
        let number = eNumber.trimmingCharacters(in: trimCharacterSet)
        return "E\(number)"
    }
}

fileprivate let itemEntityName = "Item"
