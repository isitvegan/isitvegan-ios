import UIKit

class DetailViewPropertyCell: CustomTableViewCell {
    var titleLabelText: String? = nil {
        didSet {
            titleLabel.text = titleLabelText
        }
    }
    var valueLabelText: String? = nil {
        didSet {
            valueLabel.text = valueLabelText
        }
    }
    var descriptionLabelText: String? = nil {
        didSet {
            descriptionLabel.text = descriptionLabelText
        }
    }

    var link: URL? = nil

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let descriptionLabel = createDescriptionLabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        innerView = createHorizontalStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createHorizontalStack() -> UIStackView {
        return StackViewBuilder()
            .axis(.horizontal)
            .distribution(.equalSpacing)
            .alignment(.top)
            .addSubview(titleLabel)
            .addSubview(createVerticalStack())
            .build()
    }

    private func createVerticalStack() -> UIStackView {
        return StackViewBuilder()
            .axis(.vertical)
            .alignment(.trailing)
            .addSubview(valueLabel)
            .addSubview(descriptionLabel)
            .build()
    }

    private static func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = Color.secondaryLabel
        return label
    }
}
