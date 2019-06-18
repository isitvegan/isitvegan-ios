import Foundation

class DummyItemsLoader {
    private let itemsDeserializer: ItemsDeserializer
    
    init(itemsDeserializer: ItemsDeserializer) {
        self.itemsDeserializer = itemsDeserializer
    }
}

extension DummyItemsLoader: ItemsLoader {
    func loadItems() -> [Item] {
        let filePath = Bundle.main.path(forResource: "items", ofType: "json")!
        let fileContents = try! String(contentsOfFile: filePath)
        return try! self.itemsDeserializer.deserializeItems(from: fileContents.data(using: .utf8)!)
    }
}
