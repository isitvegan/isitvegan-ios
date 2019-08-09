import UIKit

class DetailViewTextCell: UITableViewCell {
    let textView = createReadonlyTextView()

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)

        contentView.addSubview(textView)
        contentView.addConstraints([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }

    private static func createReadonlyTextView() -> ReadonlyTextView {
        let textView = ReadonlyTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
