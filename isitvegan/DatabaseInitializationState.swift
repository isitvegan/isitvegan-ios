import UIKit

enum DatabaseInitializationState {
    case uninitialized
    case initialized
}

protocol DatabaseInitializationStateRepository {
    func read() -> DatabaseInitializationState

    func write(value: DatabaseInitializationState)
}

class DatabaseInitializationStateRepositoryImpl {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

extension DatabaseInitializationStateRepositoryImpl: DatabaseInitializationStateRepository {
    func read() -> DatabaseInitializationState {
        let isInitialized = userDefaults.bool(forKey: databaseInitializedKey)

        if isInitialized {
            return .initialized
        } else {
            return .uninitialized
        }
    }

    func write(value: DatabaseInitializationState) {
        switch value {
        case .initialized:
            userDefaults.set(true, forKey: databaseInitializedKey)
        case .uninitialized:
            userDefaults.removeObject(forKey: databaseInitializedKey)
        }
        userDefaults.synchronize()
    }
}

fileprivate let databaseInitializedKey = "databaseInitialized"
