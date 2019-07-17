import Foundation
import UIKit

protocol RootView {
    func showSearchView()

    func showLoadingView()

    func showLoadingErrorView(retry: @escaping () -> Void)
}

class RootViewController: UIViewController {
    typealias LoadingErrorViewFactory = (_ retryLoading: @escaping () -> Void) -> UIViewController

    private let controller: RootController
    private let createSearchView: () -> UIViewController
    private let createLoadingView: () -> UIViewController
    private let createLoadingErrorView: LoadingErrorViewFactory

    private var childViewController: UIViewController?

    init(controller: RootController,
         createSearchView: @escaping () -> UIViewController,
         createLoadingView: @escaping () -> UIViewController,
         createLoadingErrorView: @escaping LoadingErrorViewFactory) {
        self.controller = controller
        self.createSearchView = createSearchView
        self.createLoadingView = createLoadingView
        self.createLoadingErrorView = createLoadingErrorView
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        controller.run()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewController: RootView {
    func showSearchView() {
        setChildViewController(createSearchView())
    }

    func showLoadingView() {
        setChildViewController(createLoadingView())
    }

    func showLoadingErrorView(retry: @escaping () -> Void) {
        setChildViewController(createLoadingErrorView(retry))
    }
}

extension RootViewController {
    private func setChildViewController(_ childViewController: UIViewController) {
        removeChildViewController()
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }

    private func removeChildViewController() {
        if let childViewController = self.childViewController {
            childViewController.willMove(toParent: nil)
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
    }
}
