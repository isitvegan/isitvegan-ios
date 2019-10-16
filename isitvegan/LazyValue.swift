import Foundation

class LazyValue<T> {
    private var state: LazyValueState<T>

    init(_ loadValue: @escaping () -> T) {
        state = .initial(loadValue)
    }

    func value() -> T {
        switch state {
        case .initial(let loadValue):
            let value = loadValue()
            state = .loaded(value)
            return value
        case .loaded(let value):
            return value
        }
    }
}

fileprivate enum LazyValueState<T> {
    case initial(() -> T)
    case loaded(T)
}
