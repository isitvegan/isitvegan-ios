import Foundation

protocol DetailPresenter {
    var view: DetailView! { get set }

    func present(item: Item)
}

class DetailPresenterImpl {
    var view: DetailView!

    private let stateViewModelMapper: StateViewModelMapper

    init(stateViewModelMapper: StateViewModelMapper) {
        self.stateViewModelMapper = stateViewModelMapper
    }
}

extension DetailPresenterImpl: DetailPresenter {
    func present(item: Item) {
        let state = stateViewModelMapper.stateToViewModel(item.state)
        let viewItem = DetailViewItem(name: item.name, state: state, cells: mapToCells(item: item))
        view.show(item: viewItem)
    }

    private func mapToCells(item: Item) -> [[DetailViewItem.Cell]] {
        let cells: [[DetailViewItem.Cell]?] = [
            createDescriptionCells(item: item),
            createENumberCells(item: item),
            createSourcesCells(item: item),
        ]

        return cells.compactMap { $0 }
    }

    private func createDescriptionCells(item: Item) -> [DetailViewItem.Cell]? {
        let description = item.description.replacingOccurrences(of: "\n", with: " ")
        return description.isEmpty ? nil : [DetailViewItem.Cell.text(description)]
    }

    private func createENumberCells(item: Item) -> [DetailViewItem.Cell]? {
        item.eNumber.map { eNumber in
            let cell = DetailViewItem.Cell.property(DetailViewItem.PropertyCell(
                title: "E number", value: eNumber, description: nil, link: nil
            ))
            return [cell]
        }
    }

    private func createSourcesCells( item: Item) -> [DetailViewItem.Cell]? {
        let sources = item.sources.value()
        if (sources.isEmpty) {
            return nil
        } else {
            return sources.enumerated().map { (index, source) in
                let title = index == 0 ? "Sources" : ""
                let description = source.lastChecked.map(formatLastCheckedDate(date:))

                return DetailViewItem.Cell.property(DetailViewItem.PropertyCell(
                    title: title,
                    value: extractDomainFromUrl(url: source.value) ?? "",
                    description: description,
                    link: URL(string: source.value)))
            }
        }
    }

    private func formatLastCheckedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        return "Last checked: \(formattedDate)"
    }

    private func extractDomainFromUrl(url: String) -> String? {
        let wwwPrefix = "www."
        guard let url = URL(string: url) else { return nil }
        guard let host = url.host else { return nil }
        return host.deletingPrefix(wwwPrefix)
    }
}
