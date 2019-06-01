import CoreSpotlight
import UIKit
import MobileCoreServices

class SpotlightIndexerImpl {
    private var searchableIndex: CSSearchableIndex
    
    init(searchableIndex: CSSearchableIndex) {
        self.searchableIndex = searchableIndex
    }
    
    private func mapItemToSearchableItem(_ item: Item) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
        attributeSet.title = "\(item.name) · \(getItemStateDescription(item.state))"
        attributeSet.contentDescription = item.description
        attributeSet.thumbnailData = mapItemStateToThumbnail(item.state)
        return CSSearchableItem(uniqueIdentifier: item.id, domainIdentifier: "item", attributeSet: attributeSet)
    }
    
    private func getItemStateDescription(_ state: Item.State) -> String {
        switch (state) {
        case .vegan:
            return "vegan"
        case .carnist:
            return "carnist"
        case .itDepends:
            return "it depends"
        }
    }

    private func mapItemStateToThumbnail(_ state: Item.State) -> Data? {
        switch (state) {
        case .vegan:
            return createThumbnail(name: "vegan")
        case .carnist:
            return createThumbnail(name: "carnist")
        default:
            return nil
        }
    }
    
    private func createThumbnail(name: String) -> Data? {
        return UIImage(named: name)?.pngData()
    }
}

extension SpotlightIndexerImpl: SpotlightIndexer {
    func index(items: [Item]) {
        let searchableItems = items.map { mapItemToSearchableItem($0) }
        searchableIndex.indexSearchableItems(searchableItems)
    }

    func deleteAll() {
        searchableIndex.deleteAllSearchableItems()
    }
}
