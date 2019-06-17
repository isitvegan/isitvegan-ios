import UIKit

struct SearchViewItem {
    let name: String
    
    init(name: String) {
        self.name = name
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

        tableViewController.navigationItem.searchController = UISearchController()
        tableViewController.navigationItem.searchController?.automaticallyShowsScopeBar = true
        tableViewController.navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        tableViewController.navigationItem.searchController?.searchResultsUpdater = self
        tableViewController.navigationItem.searchController?.definesPresentationContext = false
        tableViewController.navigationItem.hidesSearchBarWhenScrolling = false
        tableViewController.navigationItem.searchController!.searchBar.scopeButtonTitles = [
            "Search titles",
            "Search E numbers",
        ]

        let masterViewController = UINavigationController()
        masterViewController.viewControllers = [tableViewController]
        masterViewController.navigationBar.prefersLargeTitles = true
        viewControllers.append(masterViewController)
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.text = item.name
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
        let query = searchController.searchBar.text!
        controller.search(name: query)
    }
}
