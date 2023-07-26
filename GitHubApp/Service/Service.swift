import Foundation

struct Service {
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchList(of user: String, completion: @escaping ([Repository]?) -> Void) {
        network.performGet(url: getGithubURL(for: user)) { data in
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
    
    private func getGithubURL(for user: String) -> URL {
        URL(string: "https://api.github.com/users/\(user)/repos")!
    }
}
