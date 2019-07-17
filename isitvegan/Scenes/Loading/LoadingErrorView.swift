import UIKit

class LoadingErrorViewController: UIViewController {
    private let retryLoading: () -> Void

    init(retryLoading: @escaping () -> Void) {
        self.retryLoading = retryLoading
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.systemBackground

        let stack = createVerticalStack()
        view.addSubview(stack)
        view.addConstraints([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func createVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2

        stack.addArrangedSubview(createTitle())
        let description = createDescription()
        stack.addArrangedSubview(description)
        stack.setCustomSpacing(16, after: description)
        stack.addArrangedSubview(createRetryButton())

        return stack
    }

    private func createTitle() -> UILabel {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        title.text = "Could not load items"
        return title
    }

    private func createDescription() -> UILabel {
        let description = UILabel()
        description.font = .preferredFont(forTextStyle: .body)
        description.textColor = Color.secondaryLabel
        description.text = "You are no longer connected to the internet"
        return description
    }

    private func createRetryButton() -> UIButton {
        let button = RoundedButton()
        button.setTitle("RETRY", for: [.normal])
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func onButtonTapped() {
        self.retryLoading()
    }
}
