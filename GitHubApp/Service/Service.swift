import Foundation

struct Service {
    
    private let network: NetworkProtocol
    private lazy var githubURL: (String) -> URL = { user in
        URL(string: "https://api.github.com/users/\(user)/repos")!
    }
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    mutating func fetchList(of user: String, completion: @escaping ([Repository]?) -> Void) {
        network.performGet(url: githubURL(user)) { data in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let repositories: [Repository] = try JSONDecoder().decode([Repository].self, from: data)
                completion(repositories)
            } catch {
                completion(nil)
            }
        }
    }
}
