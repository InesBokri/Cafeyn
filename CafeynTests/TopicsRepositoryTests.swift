//
//  TopicsRepositoryTests.swift
//  CafeynTests
//
//  Created by Ines BOKRI on 07/11/2024.
//

import XCTest
@testable import Cafeyn

class TopicRepositoryTests: XCTestCase {
    var repository: TopicRepository!
    var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        repository = TopicRepository()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests for Fetching Topics
    
    func testFetchTopics_fromEndpoint_returnsTopics() {
        // Assuming fetchTopics is async, set up an expectation
        let expectation = XCTestExpectation(description: "Fetch topics from endpoint")
        
        repository.fetchTopics { result in
            switch result {
            case .success(let topics):
                XCTAssertFalse(topics.isEmpty, "Topics should not be empty")
                XCTAssertEqual(topics.count, 25) // assuming the endpoint returns 25 items
                
            case .failure(let error):
                XCTFail("Fetching topics failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        // Wait for expectation
        wait(for: [expectation], timeout: 5.0)
    }
}
