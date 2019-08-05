import UIKit

class RoundedButton: UIButton {
    init() {
        super.init(frame: .zero)
        setTitle("", for: [.normal])
        backgroundColor = tintColor
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        contentEdgeInsets = .init(top: 5, left: 15, bottom: 5, right: 15)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        backgroundColor = tintColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
