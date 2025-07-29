//
//  MockAPIService.swift
//  UnitTesting
//

@testable import UnitTesting

final class MockAPIService: APIServiceProtocol {
    var fetchUsersResult: Result<[User], APIError>?
    
    private(set) var fetchUsersCallsCount = 0
    private(set) var lastReceivedUrl: String?

    func fetchUsers(
            urlString: String,
            completion: @escaping (Result<[User], APIError>) -> Void
    ) {
        fetchUsersCallsCount += 1
        lastReceivedUrl = urlString

        if let result = fetchUsersResult {
            completion(result)
        } else {
            completion(.failure(.unexpected))
        }
    }

    func fetchUsersAsync(urlString: String) async -> Result<[User], APIError> {
        lastReceivedUrl = urlString
        return fetchUsersResult ?? .failure(.unexpected)
    }
}
