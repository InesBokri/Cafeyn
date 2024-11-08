//
//  TopicsViewModel.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 30/10/2024.
//

import UIKit

class TopicsViewModel {
    
    // MARK: - Properties
    private let repository: TopicRepositoryProtocol
    var topics = [Topic]()
    var filtredTopics = [Topic]()
    
    var combinedTopicNames: [String] {
        return topics.flatMap { topic in
            // the topic name
            var names = [topic.name.raw]
            // subtopics if they exist
            if let subTopics = topic.subTopics {
                let subTopicNames = subTopics.map { $0.name.raw }
                names.append(contentsOf: subTopicNames)
            }
            return names
        }
    }
    
    // MARK: - Initializer
    init(repository: TopicRepositoryProtocol = TopicRepository()) {
        self.repository = repository
    }

    // MARK: - Functions
    func retrieveTopics(completion: @escaping (_ topics: [Topic]?, _ error: String?) -> Void) {
        let favoriteTopics = loadFavoriteTopics()
        repository.fetchTopics { [weak self] result in
            switch result {
            case .success(let topics):
               /* let filteredTopics = favoriteTopics.isEmpty ? topics : topics.filter {
                    !favoriteTopics.contains($0.name.raw)
                } */
                self?.topics = topics
                completion(topics, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func saveTopics(_ topics: [String]) {
        repository.saveFavoriteTopics(topics)
    }
    
    func loadFavoriteTopics() -> [String] {
        repository.loadFavoriteTopics()
    }
}
