import Foundation
import UIKit

class StateIndicatorView: UIView {
    var imageName: ImageName? {
        didSet {
            if let imageName = imageName {
                if #available(iOS 13.0, *) {
                    imageView.image = UIImage(systemName: imageName.rawValue)
                } else {
                    imageView.image = UIImage(named: imageName.rawValue)?.withRenderingMode(.alwaysTemplate)
                }
                imageView.sizeToFit()
            }
        }
    }

    var text: String? {
        didSet {
            labelView.text = text
            labelView.sizeToFit()
        }
    }

    var color: UIColor? {
        didSet {
            labelView.textColor = color
            imageView.tintColor = color
        }
    }
    
    private let stackView: UIStackView = createStackView()
    private let labelView: UILabel = createLabelView()
    private let imageView: UIImageView = createImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func createStackView() -> UIStackView {
        let stackView = StackViewBuilder()
            .spacing(2)
            .alignment(.center)
            .build()
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return stackView
    }

    private static func createLabelView() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }

    private static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }

    private func setupSubViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(imageView)

        addConstraints([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
