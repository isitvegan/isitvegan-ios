import UIKit

struct DatabaseVersion: RawRepresentable, Hashable, Equatable {
    let rawValue: Int

    init(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }

    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

enum DatabaseInitializationState {
    case uninitialized
    case initialized(DatabaseVersion)
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
        let version = userDefaults.object(forKey: databaseVersion) as? Int
        return version.map({ .initialized(DatabaseVersion($0)) }) ?? .uninitialized
    }

    func write(value: DatabaseInitializationState) {
        switch value {
        case .initialized(let version):
            userDefaults.set(version.rawValue, forKey: databaseVersion)
        case .uninitialized:
            userDefaults.removeObject(forKey: databaseVersion)
        }
        userDefaults.synchronize()
    }
}

fileprivate let databaseVersion = "databaseVersion"
