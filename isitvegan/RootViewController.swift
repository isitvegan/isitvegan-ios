import UIKit

class RootViewController: UISplitViewController, UISplitViewControllerDelegate, UITableViewDataSource {
    private var tableViewController: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        
        let table = UITableViewController()
        let tableView = (table.view as! UITableView)
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableCell", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
        tableView.allowsSelection = false
        
        table.navigationItem.title = "Is it Vegan?"
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        table.navigationItem.searchController = UISearchController()
        table.navigationItem.searchController!.automaticallyShowsScopeBar = true
        table.navigationItem.hidesSearchBarWhenScrolling = false
        table.navigationItem.searchController!.searchBar.scopeButtonTitles = [
            "Search titles",
            "Search E numbers",
        ]
        
        tableViewController = table

        let master = UINavigationController()
        master.viewControllers = [table]
        master.navigationBar.prefersLargeTitles = true

        let detail = UIViewController()
        let navigationDetail = UINavigationController(rootViewController: detail)
        detail.navigationItem.title = "Oat Milk"
        detail.title = "Oat Milk"
        
        let detailView = Bundle.main.loadNibNamed("DetailView", owner: nil)?.first as! DetailView?
        // detailView?.imageView.image = UIImage(named: "carnist")!
        detailView?.descriptionLabel.text = "Given the chance, cows nurture their young and form lifelong friendships with one another."
        detailView?.descriptionLabel.sizeToFit()
        detail.view = detailView
        viewControllers.append(master)

        showDetailViewController(navigationDetail, sender: nil)
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return false
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.tableViewController.refreshControl?.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCellView
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        cell.fooLabel!.text = "Row \(indexPath.row)"
        cell.accessoryType = .disclosureIndicator
        return cell

        // let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        // cell.accessoryType = .disclosureIndicator
        // cell.textLabel!.text = "Row \(indexPath.row)"
        // cell.contentView.addSubview(UIImageView(image: UIImage(named: "vegan")!))
        // return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
