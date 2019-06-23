import UIKit

struct DetailViewItem {
    let name: String
    let description: String
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
        
        let scrollView = UIScrollView(frame: view.frame)
        view.addSubview(scrollView)
        
        let verticalStack = UIStackView()
        scrollView.addSubview(verticalStack)
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.spacing = 10
        verticalStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        verticalStack.isLayoutMarginsRelativeArrangement = true
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0

        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(descriptionLabel)

        view.addConstraints([
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
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
    }
    
    func asUIViewController() -> UIViewController {
        self
    }
}
