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
        let description = item.description.replacingOccurrences(of: "\n", with: " ")
        let state = stateViewModelMapper.stateToViewModel(item.state)
        let viewItem = DetailViewItem(name: item.name, description: description, state: state, propertyGroups: mapToPropertyGroups(item: item))
        view.show(item: viewItem)
    }

    private func mapToPropertyGroups(item: Item) -> [DetailViewItem.PropertyGroup] {
        var propertyGroups: [DetailViewItem.PropertyGroup] = []

        if let propertyGroup = createENumberPropertyGroup(item: item) {
            propertyGroups.append(propertyGroup)
        }

        return propertyGroups
    }

    private func createENumberPropertyGroup(item: Item) -> DetailViewItem.PropertyGroup? {
        item.eNumber.map { eNumber in
            DetailViewItem.PropertyGroup(properties: [
                DetailViewItem.Property(title: "E number", value: eNumber, description: nil, link: nil)
            ])
        }
    }
}
