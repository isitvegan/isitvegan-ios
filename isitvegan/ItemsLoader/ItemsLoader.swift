protocol ItemsLoader {
    func loadItems(completion: @escaping (Result<[Item], Error>) -> Void)
}
