import UIKit

struct SearchViewItem {
    let name: String
    let eNumber: String
    let stateDescription: String
    let stateImageName: String
    let stateColor: UIColor
    
    init(name: String,
         eNumber: String,
         stateDescription: String,
         stateImageName: String,
         stateColor: UIColor) {
        self.name = name
        self.eNumber = eNumber
        self.stateDescription = stateDescription
        self.stateImageName = stateImageName
        self.stateColor = stateColor
    }
}

protocol SearchView {
    func listItems(items: [SearchViewItem], itemsNotShownDueToLimit: Int)

    func showDetailView(_ detailView: UIViewController)
}

class SearchViewController: UISplitViewController {
    private let controller: SearchController
    private let cellClass: AnyClass

    private weak var tableView: UITableView?
    private weak var refreshControl: UIRefreshControl?
    private var tableFooterView: UILabel?

    private var items: [SearchViewItem] = []
    private var itemsNotShownDueToLimit: Int = 0
    
    private let searchScopes: [SearchScope] = [
        SearchScope(buttonTitle: "Search names", kind: .names, keyboardType: .default),
        SearchScope(buttonTitle: "Search E numbers", kind: .eNumbers, keyboardType: .numberPad),
    ]

    init(controller: SearchController,
         cellClass: AnyClass) {
        self.controller = controller
        self.cellClass = cellClass
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller.listItems()

        delegate = self
        preferredDisplayMode = .allVisible
        
        let tableViewController = UITableViewController(style: .grouped)

        tableView = tableViewController.view as? UITableView
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(self.cellClass, forCellReuseIdentifier: cellReuseIdentifier)

        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl = tableViewController.refreshControl
        
        tableViewController.navigationItem.title = "Is it Vegan?"

        tableViewController.navigationItem.searchController = createSearchController()
        tableViewController.navigationItem.hidesSearchBarWhenScrolling = false

        let masterViewController = UINavigationController()
        masterViewController.viewControllers = [tableViewController]
        masterViewController.navigationBar.prefersLargeTitles = true

        viewControllers.append(masterViewController)
    }

    private func createSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.automaticallyShowsScopeBar = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = false
        searchController.searchBar.scopeButtonTitles = searchScopes.map { $0.buttonTitle }
        searchController.searchBar.delegate = self
        return searchController
    }

    @objc private func handleRefreshControl() {
        self.controller.refreshItems(completion: {
            self.refreshControl?.endRefreshing()
        })
    }
}

extension SearchViewController: SearchView {
    func listItems(items: [SearchViewItem], itemsNotShownDueToLimit: Int) {
        self.items = items
        self.itemsNotShownDueToLimit = itemsNotShownDueToLimit
        tableView?.reloadData()
    }
    
    func showDetailView(_ detailView: UIViewController) {
        showDetailViewController(detailView, sender: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ItemTableViewCell
        cell.setName(item.name)
        cell.setStateImageName(item.stateImageName)
        cell.setStateDescription(item.stateDescription)
        cell.setStateColor(item.stateColor)
        cell.setENumber(item.eNumber)
        return cell.asUITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch itemsNotShownDueToLimit {
        case 0:
            return nil
        case 1:
            return "1 additional item is not show"
        default:
            return "\(itemsNotShownDueToLimit) additional items are not shown"
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        controller.showDetail(itemIndex: indexPath.item)
    }
}

extension SearchViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        let applyDefaultBehavior = false
        return applyDefaultBehavior
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        let scope = searchScopes[scopeIndex].kind

        switch (scope) {
        case .names:
            controller.search(name: searchTerm)
        case .eNumbers:
            controller.search(eNumber: searchTerm)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchScopes[selectedScope]
        searchBar.searchTextField.keyboardType = scope.keyboardType
        searchBar.searchTextField.reloadInputViews()
    }
}

extension SearchViewController {
    private struct SearchScope {
        let buttonTitle: String
        let kind: SearchScopeKind
        let keyboardType: UIKeyboardType
    }

    private enum SearchScopeKind {
        case names
        case eNumbers
    }
}

fileprivate let cellReuseIdentifier = "ItemCell"
