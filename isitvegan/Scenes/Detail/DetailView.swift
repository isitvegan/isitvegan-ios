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
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        let scrollView = createScrollView()
        view.addSubview(scrollView)
        
        let verticalStack = createVerticalStack()
        scrollView.addSubview(verticalStack)

        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .body)

        stateIndicatorView = StateIndicatorView()

        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(stateIndicatorView)
        verticalStack.addArrangedSubview(descriptionLabel)

        view.addConstraints([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])

        scrollView.addConstraints([
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            verticalStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            verticalStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            verticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
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

        stateIndicatorView.image = UIImage(systemName: item.state.imageName)!
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
        verticalStack.spacing = 10
        verticalStack.isLayoutMarginsRelativeArrangement = true
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        return verticalStack
    }
}
