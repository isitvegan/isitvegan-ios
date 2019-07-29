protocol ConditionalStorageResetter {
    func resetStorageIfNeeded(completion: @escaping (_ result: Result<Void, Error>) -> Void)
}

protocol StorageResetter {
    var databaseVersion: DatabaseVersion { get }

    func resetStorage() -> Result<Void, Error>

    func initializeStorage() -> Result<Void, Error>
}

class ConditionalStorageResetterImpl {
    let databaseInitializationStateRepository: DatabaseInitializationStateRepository
    let storageResetter: StorageResetter
    let storageUpdater: ItemsStorageUpdater

    init(databaseInitializationStateRepository: DatabaseInitializationStateRepository,
         storageResetter: StorageResetter,
         storageUpdater: ItemsStorageUpdater) {
        self.databaseInitializationStateRepository = databaseInitializationStateRepository
        self.storageResetter = storageResetter
        self.storageUpdater = storageUpdater
    }
}

extension ConditionalStorageResetterImpl: ConditionalStorageResetter {
    func resetStorageIfNeeded(completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        if needsResetting() {
            resetStorage(completion: completion)
        } else {
            completion(.success(()))
        }
    }

    private func resetStorage(completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        let expectedVersion = storageResetter.databaseVersion
        let result = storageResetter.resetStorage().flatMap { storageResetter.initializeStorage() }

        switch result {
        case .failure(let error):
            completion(.failure(error))
        case .success(_):
            storageUpdater.updateItems { result in
                completion(result.map { self.databaseInitializationStateRepository.write(value: .initialized(expectedVersion)) })
            }
        }
    }

    private func needsResetting() -> Bool {
        let expectedVersion = storageResetter.databaseVersion
        let initializationState = databaseInitializationStateRepository.read()
        switch initializationState {
        case .uninitialized:
            return true
        case .initialized(let version):
            return version != expectedVersion
        }
    }
}
