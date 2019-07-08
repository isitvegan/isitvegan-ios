import Foundation

protocol ItemsDeserializer {
    func deserializeItems(from data: Data) -> Result<[Item], Error>
}
