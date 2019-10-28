import UIKit
import SafariServices

struct DetailViewItem {
    enum Cell {
        case text(String)
        case property(PropertyCell)
    }

    struct PropertyCell {
        let title: String
        let value: String
        let description: String?
        let link: URL?
    }

    let name: String
    let state: StateViewModel
    let cells: [[Cell]]
}

protocol DetailView {
    func show(item: DetailViewItem)
    
    func asUIViewController() -> UIViewController
}

class DetailViewController: UITableViewController {
    private let controller: DetailController
    private let item: Item

    private var cells: [[DetailViewItem.Cell]] = []

    private var titleLabel: UILabel!
    private var descriptionLabel: UITextView!
    private var stateIndicatorView: StateIndicatorView!

    init(controller: DetailController, item: Item) {
        self.controller = controller
        self.item = item
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupView()
        controller.show(item: item)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView.tableHeaderView else {
          return
        }

        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        let height = size.height

        if headerView.frame.size.height != height {
            headerView.frame.size.height = height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
}

extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfig = cells[indexPath.section][indexPath.row]
        switch cellConfig {
        case .text(let text):
            return createTextCell(text: text)
        case .property(let propertyCell):
            return createPropertyCell(propertyCell: propertyCell)
        }
    }

    private func createTextCell(text: String) -> UITableViewCell {
        let cell = DetailViewTextCell(style: .default, reuseIdentifier: nil)
        cell.textView.text = text
        cell.isUserInteractionEnabled = false
        return cell
    }

    private func createPropertyCell(propertyCell: DetailViewItem.PropertyCell) -> UITableViewCell {
        let cell = DetailViewPropertyCell(style: .default, reuseIdentifier: nil)
        cell.titleLabelText = propertyCell.title
        cell.valueLabelText = propertyCell.value
        cell.isUserInteractionEnabled = false

        if let _ = propertyCell.link {
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = true
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorContainer = UIView(frame: .zero)
        let separator = UIView(frame: .zero)
        separator.backgroundColor = Color.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separatorContainer.addSubview(separator)
        separatorContainer.addConstraints([
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 15),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor, constant: -15),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor, constant: 10),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor, constant: -10),
        ])
        return separatorContainer
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let cellConfig = cells[indexPath.section][indexPath.row]
        if case .property(let propertyCell) = cellConfig {
            if let url = propertyCell.link {
                let viewController = SFSafariViewController(url: url)
                viewController.delegate = self
                present(viewController, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 + 1.0 / UIScreen.main.scale
    }
}

extension DetailViewController: DetailView {
    func show(item: DetailViewItem) {
        titleLabel.text = item.name
        titleLabel.sizeToFit()

        cells = item.cells

        stateIndicatorView.imageName = item.state.imageName
        stateIndicatorView.color = item.state.color
        stateIndicatorView.text = item.state.title

        tableView.reloadData()
        tableView.tableHeaderView?.setNeedsLayout()
        tableView.tableHeaderView?.layoutIfNeeded()
    }
    
    func asUIViewController() -> UIViewController {
        self
    }
}

extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension DetailViewController {
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never

        titleLabel = createTitleLabel()
        stateIndicatorView = createStateIndicatorView()

        let headerStack = StackViewBuilder()
            .axis(.vertical)
            .alignment(.center)
            .spacing(10)
            .layoutMargins(.init(top: 20, left: 0, bottom: 10, right: 0))
            .addSubview(titleLabel)
            .addSubview(stateIndicatorView, spacingAfter: 20)
            .build()

        insertSeparator(headerStack)

        tableView.tableHeaderView = headerStack
        tableView.separatorStyle = .none

        tableView.addConstraints([
            headerStack.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            headerStack.widthAnchor.constraint(equalTo: tableView.widthAnchor),
        ])
    }

    private func createTitleLabel() -> UILabel {
        let titleLabel = CopyableLabel()
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = Color.label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        return titleLabel
    }

    private func createStateIndicatorView() -> StateIndicatorView {
        let stateIndicator = StateIndicatorView()
        stateIndicator.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        return stateIndicator
    }

    private func createDescriptionLabel() -> UITextView {
        let descriptionLabel = ReadonlyTextView()
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
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
