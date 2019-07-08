extension Result {
    init(result: Success?, error: Failure?) {
        if let result = result {
            self = .success(result)
        } else {
            self = .failure(error!)
        }
    }
}
