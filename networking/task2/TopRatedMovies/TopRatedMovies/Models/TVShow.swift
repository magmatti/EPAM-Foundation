import Foundation

struct TVShow: Codable {
    
    let name: String
    let firstAirDate: String
    let voteAverage: Double
    let originCountry: [String]
    let popularity: Double
    let overview: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case originCountry = "origin_country"
        case popularity
        case overview
        case posterPath = "poster_path"
    }
}
