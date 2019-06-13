import UIKit

class RootViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
