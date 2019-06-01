import Foundation

protocol ItemsDeserializer {
    func deserializeItems(from data: Data) throws -> [Item]
}
