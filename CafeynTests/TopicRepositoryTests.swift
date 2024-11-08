//
//  TopicRepositoryTests.swift
//  CafeynTests
//
//  Created by Ines BOKRI on 07/11/2024.
//

import XCTest
@testable import Cafeyn

// mock for URLSession to control the response
class MockURLSession: URLSession {
    var data: Data?
    var error: Error?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, nil, error)
        return URLSession.shared.dataTask(with: url)
    }
}


final class TopicRepositoryTests: XCTestCase {
        
        var repository: TopicRepository!
        var mockSession: MockURLSession!
        
        override func setUp() {
            super.setUp()
            mockSession = MockURLSession()
            repository = TopicRepository()
        }
        
        func testFetchTopics_Success() {
            // Prepare mock data
            let sampleTopics = [Topic(id: "1", name: TopicName(raw: "cinema", key: "cinema1"), color: "blanc", subTopics: [] )
                                Topic(id: "2", name: TopicName(raw: "musique", key: "musique2"), color: "rouge", subTopics: [])]
            let data = try! JSONEncoder().encode(sampleTopics)
            mockSession.data = data

            // Perform fetchTopics
            let expectation = XCTestExpectation(description: "Fetch topics succeeds")
            repository.fetchTopics { result in
                switch result {
                case .success(let topics):
                    XCTAssertEqual(topics.count, sampleTopics.count)
                    XCTAssertEqual(topics.first?.name, "Tech")
                case .failure:
                    XCTFail("Expected success but got failure")
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }

        func testFetchTopics_Failure() {
            // Set mock error
            mockSession.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)
            
            let expectation = XCTestExpectation(description: "Fetch topics fails")
            repository.fetchTopics { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertNotNil(error)
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
        
        // Other test cases...
    }
