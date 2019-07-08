protocol ItemsStorageUpdater {
    func updateItems(completion: @escaping (_ result: Result<Void, Error>) -> Void)
}
