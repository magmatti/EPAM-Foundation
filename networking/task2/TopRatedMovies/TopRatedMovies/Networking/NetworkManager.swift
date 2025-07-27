import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchTopRatedTVShows(completion: @escaping (Result<[TVShow], NetworkError>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/top_rated?api_key=7481bbcf1fcb56bd957cfe9af78205f3&language=en-US&page=1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
