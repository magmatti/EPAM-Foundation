//
//  UsersViewModelTests.swift
//  UnitTesting
//

@testable import UnitTesting
import XCTest

class UsersViewModelTests: XCTestCase {
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    // assert that sut.fetchUsers(completion: {}) calls appropriate method of api service
    // use XCAssertEqual, fetchUsersCallsCount
    func test_viewModel_whenFetchUsers_callsApiService() {
        let sut = makeSut()
        let expectation = self.expectation(description: "API call")

        sut.fetchUsers {
            XCTAssertEqual(self.mockService.fetchUsersCallsCount, 1)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that the passed url to api service is correct
    func test_viewModel_whenFetchUsers_passesCorrectUrlToApiService() {
        let sut = makeSut()
        let expectation = self.expectation(description: "Correct URL")

        sut.fetchUsers {
            XCTAssertEqual(self.mockService.lastReceivedUrl, "https://jsonplaceholder.typicode.com/users")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that view model users are updated and error message is nil
    func test_viewModel_fetchUsers_whenSuccess_updatesUsers() {
        mockService.fetchUsersResult = .success([
            User(id: 1, name: "name", username: "surname", email: "user@email.com")
        ])
        let sut = makeSut()
        let expectation = self.expectation(description: "Success")

        sut.fetchUsers {
            XCTAssertEqual(sut.users.count, 1)
            XCTAssertEqual(sut.users[0].name, "name")
            XCTAssertNil(sut.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that view model error message is "Unexpected error"
    func test_viewModel_fetchUsers_whenInvalidUrl_updatesErrorMessage() {
        mockService.fetchUsersResult = .failure(.invalidUrl)
        let sut = makeSut()
        let expectation = self.expectation(description: "Invalid URL")

        sut.fetchUsers {
            XCTAssertEqual(sut.errorMessage, "Unexpected error")
            XCTAssertTrue(sut.users.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that view model error message is "Unexpected error"
    func test_viewModel_fetchUsers_whenUnexectedFailure_updatesErrorMessage() {
        mockService.fetchUsersResult = .failure(.unexpected)
        let sut = makeSut()
        let expectation = self.expectation(description: "Unexpected error")

        sut.fetchUsers {
            XCTAssertEqual(sut.errorMessage, "Unexpected error")
            XCTAssertTrue(sut.users.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // assert that view model error message is "Error parsing JSON"
    func test_viewModel_fetchUsers_whenParsingFailure_updatesErrorMessage() {
        mockService.fetchUsersResult = .failure(.parsingError)
        let sut = makeSut()
        let expectation = self.expectation(description: "Parsing error")

        sut.fetchUsers {
            XCTAssertEqual(sut.errorMessage, "Error parsing JSON")
            XCTAssertTrue(sut.users.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // fetch users with successful result and after calling clear() assert users are empty
    func test_viewModel_clearUsers() {
        mockService.fetchUsersResult = .success([
            User(id: 1, name: "Test", username: "Tester", email: "test@test.com")
        ])
        let sut = makeSut()
        let expectation = self.expectation(description: "Clear users")

        sut.fetchUsers {
            XCTAssertFalse(sut.users.isEmpty)
            sut.clearUsers()
            XCTAssertTrue(sut.users.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    private func makeSut() -> UsersViewModel {
        UsersViewModel(apiService: mockService)
    }
}
