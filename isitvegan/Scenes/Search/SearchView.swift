import UIKit

struct SearchViewItem {
    let name: String
    let eNumber: String
    let state: StateViewModel
    
    init(name: String,
         eNumber: String,
         state: StateViewModel) {
        self.name = name
        self.eNumber = eNumber
        self.state = state
    }
}

protocol SearchView {
    func listItems(items: [SearchViewItem],
                   createItemPreviewView: @escaping (_ itemIndex: Int) -> UIViewController)

    func showDetailView(_ detailView: UIViewController)
}

class SearchViewController: UISplitViewController {
    var createItemPreviewView: ((_ itemIndex: Int) -> UIViewController)?

    private let controller: SearchController
    private let cellClass: AnyClass

    private weak var tableView: UITableView?
    private weak var searchController: UISearchController?
    private weak var refreshControl: UIRefreshControl?
    private weak var detailViewController: UIViewController?
    private var tableFooterView: UILabel?

    private var items: [SearchViewItem] = []

    private let searchScopes: [SearchScope] = [
        SearchScope(buttonTitle: "Search names", kind: .names, keyboardType: .default),
        SearchScope(buttonTitle: "Search E numbers", kind: .eNumbers, keyboardType: .numberPad),
    ]

    init(controller: SearchController,
         cellClass: AnyClass,
         quickActionEvent: QuickActionEvent) {
        self.controller = controller
        self.cellClass = cellClass
        super.init(nibName: nil, bundle: nil)
        quickActionEvent.setHandler { [weak self] in self?.applyQuickAction($0) }
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
        tableViewController.definesPresentationContext = true

        tableView = tableViewController.tableView
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(self.cellClass, forCellReuseIdentifier: cellReuseIdentifier)

        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl = tableViewController.refreshControl
        
        tableViewController.navigationItem.title = "Is it Vegan?"

        tableViewController.navigationItem.searchController = createSearchController()
        searchController = tableViewController.navigationItem.searchController
        tableViewController.navigationItem.hidesSearchBarWhenScrolling = false

        let masterViewController = UINavigationController()
        masterViewController.viewControllers = [tableViewController]
        masterViewController.navigationBar.prefersLargeTitles = true

        viewControllers.append(masterViewController)
    }

    private func applyQuickAction(_ quickAction: QuickAction) {
        detailViewController?.navigationController?.popToRootViewController(animated: true)
        switch quickAction {
        case .SearchByName:
            selectSearchScope(searchScope: .names)
            activateSearch()
        case .SearchByENumber:
            selectSearchScope(searchScope: .eNumbers)
            activateSearch()
        }
    }

    private func activateSearch() {
        if let searchController = self.searchController {
            searchController.searchBar.isHidden = false
            searchController.isActive = true
            searchController.searchBar.becomeFirstResponder()
        }
    }

    private func selectSearchScope(searchScope: SearchScopeKind) {
        let index = searchScopes.firstIndex(where: { $0.kind == searchScope })
        searchController?.searchBar.selectedScopeButtonIndex = index!
    }

    private func createSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = false
        searchController.searchBar.scopeButtonTitles = searchScopes.map { $0.buttonTitle }
        searchController.searchBar.delegate = self
        return searchController
    }

    @objc private func handleRefreshControl() {
        self.controller.refreshItems { result in
            self.refreshControl?.endRefreshing()
            if case .failure(_) = result {
               self.showUpdateError()
            }
        }
    }

    private func showUpdateError() {
        let alert = UIAlertController(title: "Updating items failed",
                                      message: "Could not update items, because the network is currently not available.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: SearchView {
    func listItems(items: [SearchViewItem],
                   createItemPreviewView: @escaping (_ itemIndex: Int) -> UIViewController) {
        self.items = items
        self.createItemPreviewView = createItemPreviewView
        tableView?.reloadData()
    }
    
    func showDetailView(_ detailView: UIViewController) {
        detailViewController = detailView
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
        cell.setStateImageName(item.state.imageName)
        cell.setStateDescription(item.state.title)
        cell.setStateColor(item.state.color)
        cell.setENumber(item.eNumber)
        return cell.asUITableViewCell()
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                self.createItemPreviewView!(indexPath.item)
            },
            actionProvider: { _ in
                self.createContextMenu(itemIndex: indexPath.item)
            }
        )
    }
}

extension SearchViewController {
    @available(iOS 13.0, *)
    private func createContextMenu(itemIndex: Int) -> UIMenu {
        let show = UIAction(title: "Show", image: UIImage(systemName: "eye"), identifier: nil,  handler: {_ in
            self.controller.showDetail(itemIndex: itemIndex)
        })
        return UIMenu(__title: "", image: nil, identifier: nil, children: [show])
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
        searchBar.keyboardType = scope.keyboardType
        searchBar.reloadInputViews()
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
