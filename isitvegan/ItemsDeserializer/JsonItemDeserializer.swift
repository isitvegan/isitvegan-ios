import Foundation

class JsonItemDeserializer {
    private var decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
}

extension JsonItemDeserializer: ItemsDeserializer {
    func deserializeItems(from data: Data) -> Result<[Item], Error> {
        return Result {
            return try decoder.decode([Item].self, from: data)
        }
    }
}
