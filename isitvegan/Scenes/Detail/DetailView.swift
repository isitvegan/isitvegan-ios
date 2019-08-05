import UIKit

struct DetailViewItem {
    struct PropertyGroup {
        let properties: [Property]
    }

    struct Property {
        let title: String
        let value: String
        let description: String?
        let link: URL?
    }

    let name: String
    let description: String
    let state: StateViewModel
    let propertyGroups: [PropertyGroup]
}

protocol DetailView {
    func show(item: DetailViewItem)
    
    func asUIViewController() -> UIViewController
}

class DetailViewController: UIViewController {
    private let controller: DetailController
    private let item: Item
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UITextView!
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
        verticalStack.addArrangedSubview(headerStack)

        titleLabel = createTitleLabel()
        headerStack.addArrangedSubview(titleLabel)

        stateIndicatorView = StateIndicatorView()
        headerStack.addArrangedSubview(stateIndicatorView)

        insertSeparator(verticalStack)

        let contentStack = createVerticalStack()
        verticalStack.addArrangedSubview(contentStack)

        descriptionLabel = createDescriptionLabel()
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

        stateIndicatorView.imageName = item.state.imageName
        stateIndicatorView.color = item.state.color
        stateIndicatorView.text = item.state.title
    }
    
    func asUIViewController() -> UIViewController {
        self
    }
}

extension DetailViewController {
    private func createTitleLabel() -> UILabel {
        let titleLabel = CopyableLabel()
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = Color.label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }

    private func createDescriptionLabel() -> UITextView {
        let descriptionLabel = UITextView()
        descriptionLabel.isSelectable = true
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.isEditable = false
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        return descriptionLabel
    }

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
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        return stack
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
