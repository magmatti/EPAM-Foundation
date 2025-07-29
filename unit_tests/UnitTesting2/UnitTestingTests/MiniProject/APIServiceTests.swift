//
//  APIServiceTests.swift
//  UnitTesting
//

import XCTest
@testable import UnitTesting

final class APIServiceTests: XCTestCase {
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
    }
    
    override func tearDown() {
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: Fetch Users

    // pass some invalid url and assert that method completes with .failure(.invalidUrl)
    // use expectations
    func test_apiService_fetchUsers_whenInvalidUrl_completesWithError() {
        let sut = makeSut()
        let expectation = self.expectation(description: "Invalid URL")

        sut.fetchUsers(urlString: "") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .invalidUrl)
            } else {
                XCTFail("Expected failure for invalid URL")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that method completes with .success(expectedUsers)
    func test_apiService_fetchUsers_whenValidSuccessfulResponse_completesWithSuccess() {
        let response = """
        [
            { "id": 1, "name": "John Doe", "username": "johndoe", "email": "johndoe@gmail.com" },
            { "id": 2, "name": "Jane Doe", "username": "johndoe", "email": "johndoe@gmail.com" }
        ]
        """.data(using: .utf8)
        mockURLSession.mockData = response

        let sut = makeSut()
        let expectation = self.expectation(description: "Valid JSON")

        sut.fetchUsers(urlString: "https://example.com") { result in
            if case .success(let users) = result {
                XCTAssertEqual(users.count, 2)
                XCTAssertEqual(users[0].name, "John Doe")
            } else {
                XCTFail("Expected success with valid users")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that method completes with .failure(.parsingError)
    func test_apiService_fetchUsers_whenInvalidSuccessfulResponse_completesWithFailure() {
        mockURLSession.mockData = "invalid json".data(using: .utf8)

        let sut = makeSut()
        let expectation = self.expectation(description: "Invalid JSON")

        sut.fetchUsers(urlString: "https://example.com") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .parsingError)
            } else {
                XCTFail("Expected parsing error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that method completes with .failure(.unexpected)
    func test_apiService_fetchUsers_whenError_completesWithFailure() {
        mockURLSession.mockError = NSError(domain: "", code: -1)

        let sut = makeSut()
        let expectation = self.expectation(description: "Network error")

        sut.fetchUsers(urlString: "https://example.com") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .unexpected)
            } else {
                XCTFail("Expected unexpected error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // MARK: Fetch Users Async

    // pass some invalid url and assert that method completes with .failure(.invalidUrl)
    func test_apiService_fetchUsersAsync_whenInvalidUrl_completesWithError() async {
        let sut = makeSut()
        let result = await sut.fetchUsersAsync(urlString: "")

        if case .failure(let error) = result {
            XCTAssertEqual(error, .invalidUrl)
        } else {
            XCTFail("Expected failure for invalid URL")
        }
    }

    // other tests for fetchUsersAsync
    
    func test_apiService_fetchUsersAsync_whenValidSuccessfulResponse_completesWithSuccess() async {
        let response = """
        [
            { "id": 1, "name": "John Doe", "username": "johndoe", "email": "johndoe@gmail.com" }
        ]
        """.data(using: .utf8)

        mockURLSession.mockData = response
        let sut = makeSut()

        let result = await sut.fetchUsersAsync(urlString: "https://example.com")

        switch result {
        case .success(let users):
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users[0].name, "John Doe")
        case .failure:
            XCTFail("Expected success, got failure")
        }
    }

    func test_apiService_fetchUsersAsync_whenInvalidSuccessfulResponse_completesWithParsingError() async {
        mockURLSession.mockData = "invalid json".data(using: .utf8)
        let sut = makeSut()

        let result = await sut.fetchUsersAsync(urlString: "https://example.com")

        if case .failure(let error) = result {
            XCTAssertEqual(error, .parsingError)
        } else {
            XCTFail("Expected parsing error")
        }
    }

    func test_apiService_fetchUsersAsync_whenNetworkError_completesWithUnexpectedError() async {
        mockURLSession.mockError = NSError(domain: "", code: -1)
        let sut = makeSut()

        let result = await sut.fetchUsersAsync(urlString: "https://example.com")

        if case .failure(let error) = result {
            XCTAssertEqual(error, .unexpected)
        } else {
            XCTFail("Expected unexpected error")
        }
    }

    private func makeSut() -> APIService {
        APIService(urlSession: mockURLSession)
    }
}
