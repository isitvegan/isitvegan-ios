import UIKit

protocol ItemTableViewCell {
    func setStateImageName(_ name: String)
    func setStateDescription(_ description: String)
    func setStateColor(_ color: UIColor)
    func setName(_ name: String)
    func setENumber(_ eNumber: String)
    func asUITableViewCell() -> UITableViewCell
}

class TableViewCell: UITableViewCell {
    private let nameLabel: UILabel = UILabel()
    private let stateLabel: UILabel = UILabel()
    private let stateImage: UIImageView = UIImageView()
    private let eNumberLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        nameLabel.font = .preferredFont(forTextStyle: .body)
        stateLabel.font = .preferredFont(forTextStyle: .footnote)
        eNumberLabel.textColor = .secondaryLabel
        eNumberLabel.font = .preferredFont(forTextStyle: .footnote)
        stateImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.spacing = 10
        horizontalStack.alignment = .center

        let stateStack = UIStackView()
        stateStack.spacing = 2
        stateStack.alignment = .center
        stateStack.addArrangedSubview(stateLabel)
        stateStack.addArrangedSubview(stateImage)
        stateStack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        stateStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 2
        verticalStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(eNumberLabel)

        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(stateStack)

        contentView.addSubview(horizontalStack)

        contentView.addConstraints([
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            horizontalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCell: ItemTableViewCell {
    func setStateImageName(_ name: String) {
        stateImage.image = UIImage(systemName: name)
    }

    func setStateDescription(_ description: String) {
        stateLabel.text = description
    }

    func setStateColor(_ color: UIColor) {
        stateImage.tintColor = color
        stateLabel.textColor = color
    }

    func setName(_ name: String) {
        self.nameLabel.text = name
    }

    func setENumber(_ eNumber: String) {
        self.eNumberLabel.text = eNumber
        self.eNumberLabel.isHidden = eNumber.isEmpty
    }

    func asUITableViewCell() -> UITableViewCell {
        self
    }
}
