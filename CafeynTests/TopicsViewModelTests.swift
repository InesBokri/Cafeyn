//
//  TopicsViewModelTests.swift
//  CafeynTests
//
//  Created by Ines BOKRI on 07/11/2024.
//

import XCTest
@testable import Cafeyn

// Mock Repository
class MockTopicRepository: TopicRepositoryProtocol {
    var topicsToReturn: [Topic] = []
    var favoriteTopicsToReturn: [String] = []
    var errorToReturn: Error?
    
    func fetchTopics(completion: @escaping (Result<[Topic], Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(topicsToReturn))
        }
    }
    
    func saveFavoriteTopics(_ topics: [String]) {
        favoriteTopicsToReturn = topics
    }
    
    func loadFavoriteTopics() -> [String] {
        return favoriteTopicsToReturn
    }
}

final class TopicsViewModelTests: XCTestCase {
    var viewModel: TopicsViewModel!
    var mockRepository: MockTopicRepository!
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    override func setUp() {
        super.setUp()
        mockRepository = MockTopicRepository()
        viewModel = TopicsViewModel(repository: mockRepository)
    }
    
    func testRetrieveTopics_NoFavoriteTopics() {
        // Set mock data
        mockRepository.topicsToReturn = [
            Topic(id: "1", name: TopicName(raw: "Music", key: "Music-1"), color: "X1092B", subTopics: []),
            Topic(id: "2", name: TopicName(raw: "Culture", key: "Culture-02"), color: "Y4162", subTopics: [])
        ]
        
        let expectation = XCTestExpectation(description: "Retrieve topics without favorite Topics")
        
        viewModel.retrieveTopics { topics, error in
            XCTAssertNotNil(topics)
            XCTAssertEqual(topics?.count, 2)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveTopics_WithFavoriteTopics() {
        // Set mock data
        mockRepository.topicsToReturn = [
            Topic(id: "1", name: TopicName(raw: "Tech", key: "Tech-1"), color: "X1092B", subTopics: []),
            Topic(id: "2", name: TopicName(raw: "Science", key: "Science-02"), color: "Y4162", subTopics: [])
        ]
        mockRepository.favoriteTopicsToReturn = ["Tech"]
        
        let expectation = XCTestExpectation(description: "Retrieve topics with favorites")
        
        viewModel.retrieveTopics { topics, error in
            XCTAssertNotNil(topics)
            XCTAssertEqual(topics?.count, 2)
            XCTAssertEqual(topics?.first?.name.raw, "Tech")
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveTopics_WithError() {
        // Set mock error
        mockRepository.errorToReturn = NSError(domain: "NetworkError", code: -1, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Retrieve topics with error")
        
        viewModel.retrieveTopics { topics, error in
            XCTAssertNil(topics)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, "The operation couldn’t be completed. (NetworkError error -1.)") // Adjust based on expected error message format
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSaveAndLoadFavoriteTopics() {
        let favorites = ["Tech", "Science"]
        
        // Save favorites
        viewModel.saveTopics(favorites)
        XCTAssertEqual(mockRepository.favoriteTopicsToReturn, favorites)
        
        // Load favorites
        let loadedFavorites = viewModel.loadFavoriteTopics()
        XCTAssertEqual(loadedFavorites, favorites)
    }
}
