import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.systemBackground

        let activityIndicatorStyle: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            activityIndicatorStyle = .medium
        } else {
            activityIndicatorStyle = .gray
        }

        let spinner = UIActivityIndicatorView(style: activityIndicatorStyle)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        view.addConstraints([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
