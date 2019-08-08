import UIKit

class StackViewBuilder {
    private let stackView = UIStackView()

    init() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubview(_ view: UIView) -> StackViewBuilder {
        stackView.addArrangedSubview(view)
        return self
    }

    func addSubview(_ view: UIView, spacingAfter spacing: CGFloat) -> StackViewBuilder {
        let _ = addSubview(view)
        stackView.setCustomSpacing(spacing, after: view)
        return self
    }

    func axis(_ axis: NSLayoutConstraint.Axis) -> StackViewBuilder {
        stackView.axis = axis
        return self
    }

    func alignment(_ alignment: UIStackView.Alignment) -> StackViewBuilder {
        stackView.alignment = alignment
        return self
    }

    func spacing(_ spacing: CGFloat) -> StackViewBuilder {
        stackView.spacing = spacing
        return self
    }

    func layoutMargins(_ layoutMargins: UIEdgeInsets) -> StackViewBuilder {
        stackView.layoutMargins = layoutMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        return self
    }

    func build() -> UIStackView {
        return self.stackView
    }
}
