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
    var descriptionLabelText: String? = nil
    var link: URL? = nil

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
            .addSubview(valueLabel)
            .build()
    }
}
