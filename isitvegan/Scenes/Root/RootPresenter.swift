protocol RootPresenter {
    var view: RootView! { get set }

    func presentSearchView()

    func presentLoadingView()

    func presentLoadingErrorView(retry: @escaping () -> Void)
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

    func presentLoadingErrorView(retry: @escaping () -> Void) {
        view.showLoadingErrorView(retry: retry)
    }
}
