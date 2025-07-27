import Foundation

struct TVShowResponse: Codable {
    
    let page: Int
    let results: [TVShow]
}
