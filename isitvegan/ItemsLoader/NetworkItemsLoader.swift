import Foundation

class NetworkItemsLoader {
    private let itemsDeserializer: ItemsDeserializer

    init(itemsDeserializer: ItemsDeserializer) {
        self.itemsDeserializer = itemsDeserializer
    }
}

extension NetworkItemsLoader: ItemsLoader {
    func loadItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: itemsUrl, completionHandler: { (data, response, error) in
            let result = Result(result: data, error: error)
                .flatMap { items in self.itemsDeserializer.deserializeItems(from: items) }
            completion(result)
        })
        task.resume()
    }
}

fileprivate let itemsUrl: URL = URL(string: "https://www.isitvegan.app/api/v0/items")!
