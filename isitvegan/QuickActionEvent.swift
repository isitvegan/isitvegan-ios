protocol QuickActionEvent {
    func setHandler(_ handler: @escaping (QuickAction) -> Void)

    func dispatch(_ action: QuickAction)
}

class QuickActionEventImpl {
    private var handler: ((QuickAction) -> Void)? = nil
}

extension QuickActionEventImpl : QuickActionEvent {
    func setHandler(_ handler: @escaping (QuickAction) -> Void) {
        self.handler = handler
    }

    func dispatch(_ action: QuickAction) {
        print("dispatching with", action)
        self.handler?(action)
    }
}
