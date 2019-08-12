import UIKit

class CustomTableViewCell: UITableViewCell {
    var innerView: UIView! {
        didSet { addInnerViewToContentView() }
    }

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addInnerViewToContentView() {
        let verticalSpacing: CGFloat = 10
        let horizontalSpacing: CGFloat = 20

        contentView.addSubview(innerView)
        contentView.addConstraints([
            innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalSpacing),
            innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalSpacing),
            innerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalSpacing),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalSpacing),
        ])
    }
}
