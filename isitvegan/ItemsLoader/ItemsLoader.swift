protocol ItemsLoader {
    func loadItems(completion: @escaping ([Item]) -> Void)
}
