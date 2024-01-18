//
//  SearchViewModelTests.swift
//  SymmetricalFunicularTests
//
//  Created by Martin Mungai on 18/01/2024.
//

import Dispatch
import XCTest
@testable import SymmetricalFunicular

final class SearchViewModelTests: XCTestCase {
    
    var sut: SearchViewModel!

    override func setUpWithError() throws {
        
        let searchService = SearchServiceImpl(apiEnvironment: .mock)
        sut = SearchViewModel(searchService: searchService)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchRepositories() async {
        XCTAssert(sut.repositories.isEmpty)
        
        let expectation = expectation(description: "fetching repositories")
        
        
        await sut.fetchRepositories(
            username: "oooooo",
            page: 1,
            perPage: 10
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertEqual(sut.repositories.count, 28)
    }

}
