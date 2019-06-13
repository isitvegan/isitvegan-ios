import UIKit

class RootViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        
        let table = UITableViewController()
        table.navigationItem.title = "Is it Vegan?"
        table.navigationItem.searchController = UISearchController()
        table.navigationItem.searchController!.automaticallyShowsScopeBar = true
        table.navigationItem.searchController!.searchBar.scopeButtonTitles = [
            "Search titles",
            "Search E numbers",
        ]
        let master = UINavigationController()
        master.viewControllers = [table]
        master.navigationBar.prefersLargeTitles = true
        let detail = UINavigationController()
        detail.viewControllers = [UIViewController()]
        
        self.viewControllers = [master, detail]
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
