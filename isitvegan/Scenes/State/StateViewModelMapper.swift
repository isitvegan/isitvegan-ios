import UIKit

struct StateViewModel {
    let title: String
    let imageName: String
    let color: UIColor
}

protocol StateViewModelMapper {
    func stateToViewModel(_ state: Item.State) -> StateViewModel
}

class StateViewModelMapperImpl {
}

extension StateViewModelMapperImpl: StateViewModelMapper {
    func stateToViewModel(_ state: Item.State) -> StateViewModel {
        StateViewModel(title: titleFor(state: state),
                       imageName: imageNameFor(state: state),
                       color: colorFor(state: state))
    }

    private func titleFor(state: Item.State) -> String {
        switch (state) {
        case .vegan:
            return "Vegan"
        case .carnist:
            return "Carnist"
        case .itDepends:
            return "It Depends"
        }
    }

    private func imageNameFor(state: Item.State) -> String {
        switch (state) {
        case .vegan:
            return "checkmark.circle.fill"
        case .carnist:
            return "xmark.circle.fill"
        case .itDepends:
            return "questionmark.circle.fill"
        }
    }

    private func colorFor(state: Item.State) -> UIColor {
        switch (state) {
        case .vegan:
            return .veganGreen
        case .carnist:
            return .systemRed
        case .itDepends:
            return Color.secondaryLabel
        }
    }
}
