import UIKit

class LoadingViewController: UIViewController {
    private static let activityIndicatorStyle: UIActivityIndicatorView.Style = {
        if #available(iOS 13.0, *) {
            return .medium
        } else {
            return .gray
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let stack = createVerticalStack()

        view.backgroundColor = Color.systemBackground
        view.addSubview(stack)
        view.addConstraints([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func createLoadingSpinner() -> UIActivityIndicatorView {
        let activityIndicatorStyle: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            activityIndicatorStyle = .medium
        } else {
            activityIndicatorStyle = .gray
        }

        let spinner = UIActivityIndicatorView(style: activityIndicatorStyle)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }

    private func createVerticalStack() -> UIStackView {
       return StackViewBuilder()
           .axis(.vertical)
           .alignment(.center)
           .spacing(2)
           .addSubview(createLoadingSpinner(), spacingAfter: 16)
           .addSubview(createTitle())
           .addSubview(createDescription())
           .build()
    }

    private func createTitle() -> UILabel {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        title.text = "Importing items"
        return title
    }

    private func createDescription() -> UILabel {
        let description = UILabel()
        description.font = .preferredFont(forTextStyle: .body)
        description.textColor = Color.secondaryLabel
        description.text = "This might take a while"
        return description
    }
}
