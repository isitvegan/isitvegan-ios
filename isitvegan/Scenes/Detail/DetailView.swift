import UIKit

struct DetailViewItem {
    let name: String
    let description: String
    let state: StateViewModel
}

protocol DetailView {
    func show(item: DetailViewItem)
    
    func asUIViewController() -> UIViewController
}

class DetailViewController: UIViewController {
    private let controller: DetailController
    private let item: Item
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var stateIndicatorView: StateIndicatorView!

    init(controller: DetailController, item: Item) {
        self.controller = controller
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = Color.systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        let scrollView = createScrollView()
        view.addSubview(scrollView)
        
        let verticalStack = createVerticalStack()
        verticalStack.layoutMargins = .init(top: 20, left: 0, bottom: 20, right: 0)
        scrollView.addSubview(verticalStack)

        let headerStack = createHeaderStack()
        headerStack.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        verticalStack.addArrangedSubview(headerStack)

        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = Color.label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        headerStack.addArrangedSubview(titleLabel)

        stateIndicatorView = StateIndicatorView()
        headerStack.addArrangedSubview(stateIndicatorView)

        insertSeparator(verticalStack)

        let contentStack = createVerticalStack()
        verticalStack.addArrangedSubview(contentStack)

        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        view.addConstraints([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])

        scrollView.addConstraints([
            headerStack.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            contentStack.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            verticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        controller.show(item: item)
    }
}

extension DetailViewController: DetailView {
    func show(item: DetailViewItem) {
        titleLabel.text = item.name
        titleLabel.sizeToFit()
        
        descriptionLabel.text = item.description
        descriptionLabel.sizeToFit()

        if #available(iOS 13.0, *) {
            stateIndicatorView.image = UIImage(systemName: item.state.imageName)!
        } else {
            // Fallback on earlier versions
        }
        stateIndicatorView.color = item.state.color
        stateIndicatorView.text = item.state.title
    }
    
    func asUIViewController() -> UIViewController {
        self
    }
}

extension DetailViewController {
    private func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }

    private func createVerticalStack() -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.spacing = 16
        verticalStack.isLayoutMarginsRelativeArrangement = true
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        return verticalStack
    }

    private func createHeaderStack() -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 10
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        return verticalStack
    }

    private func insertSeparator(_ stackView: UIStackView) {
        let separator = UIView()
        separator.backgroundColor = Color.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(separator)
        stackView.addConstraints([
            separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            separator.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
}
