import UIKit

struct SearchViewItem {
    let name: String
    let eNumber: String
    
    init(name: String, eNumber: String) {
        self.name = name
        self.eNumber = eNumber
    }
}

protocol SearchView {
    func listItems(items: [SearchViewItem])

    func showItem(item: Item)
}

class SearchViewController: UISplitViewController {
    private let controller: SearchController
    private weak var tableView: UITableView?
    private weak var refreshControl: UIRefreshControl?
    private var items: [SearchViewItem] = []
    
    private let searchScopes: [SearchScope] = [
        SearchScope(buttonTitle: "Search names", kind: .names, keyboardType: .default),
        SearchScope(buttonTitle: "Search E numbers", kind: .eNumbers, keyboardType: .numberPad),
    ]

    init(controller: SearchController) {
        self.controller = controller
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
        
        let tableViewController = UITableViewController()

        tableView = tableViewController.view as? UITableView
        tableView?.dataSource = self
        tableView?.allowsSelection = false
        
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
        DispatchQueue.main.async {
            self.controller.refreshItems()
            self.refreshControl?.endRefreshing()
        }
    }
}

extension SearchViewController: SearchView {
    func listItems(items: [SearchViewItem]) {
        self.items = items
        self.tableView?.reloadData()
    }

    func showItem(item: Item) {
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.text = item.name
        cell.detailTextLabel?.text = item.eNumber
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
