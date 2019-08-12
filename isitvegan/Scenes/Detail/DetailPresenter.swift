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
            createDescriptionCell(item: item),
            createENumberCell(item: item),
        ]

        return cells.compactMap { $0 }
    }

    private func createDescriptionCell(item: Item) -> [DetailViewItem.Cell]? {
        let description = item.description.replacingOccurrences(of: "\n", with: " ")
        return description.isEmpty ? nil : [DetailViewItem.Cell.text(description)]
    }

    private func createENumberCell(item: Item) -> [DetailViewItem.Cell]? {
        item.eNumber.map { eNumber in
            let cell = DetailViewItem.Cell.property(DetailViewItem.PropertyCell(
                title: "E number", value: eNumber, description: nil, link: nil
            ))
            return [cell]
        }
    }
}
