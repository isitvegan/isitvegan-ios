import Foundation

class NetworkItemsLoader {
    private let itemsDeserializer: ItemsDeserializer

    init(itemsDeserializer: ItemsDeserializer) {
        self.itemsDeserializer = itemsDeserializer
    }
}

extension NetworkItemsLoader: ItemsLoader {
    func loadItems(completion: @escaping ([Item]) -> Void) {
        let task = URLSession.shared.dataTask(with: itemsUrl, completionHandler: { (data, response, error) in
            let items = try! self.itemsDeserializer.deserializeItems(from: data!)
            completion(items)
        })
        task.resume()
    }
}

fileprivate let itemsUrl: URL = URL(string: "https://www.isitvegan.app/api/v0/items")!
