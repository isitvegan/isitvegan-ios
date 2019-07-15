protocol RootPresenter {
    var view: RootView! { get set }

    func presentSearchView()

    func presentLoadingView()

    func presentLoadingErrorView()
}

class RootPresenterImpl {
    var view: RootView!
}

extension RootPresenterImpl: RootPresenter {
    func presentSearchView() {
        view.showSearchView()
    }

    func presentLoadingView() {
        view.showLoadingView()
    }

    func presentLoadingErrorView() {
        view.showLoadingErrorView()
    }
}
