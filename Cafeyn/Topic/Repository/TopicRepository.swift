//
//  TopicRepository.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 02/11/2024.
//

import UIKit

protocol TopicRepositoryProtocol {
    func fetchTopics(completion: @escaping (Result<[Topic], Error>) -> Void)
    func saveFavoriteTopics(_ topics: [String])
    func loadFavoriteTopics() -> [String]
}

class TopicRepository: TopicRepositoryProtocol {
    
    // MARK: - Properties
    private let url = URL(string: "https://b2c-api.cafeyn.co/b2c/topics/")
    private let favoritesKey = "favoriteTopics"
    
    // MARK: - functions
    // Fetch topics from endPoint
    func fetchTopics(completion: @escaping (Result<[Topic], Error>) -> Void) {
        guard let url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data else { return }
            do {
                let topics = try JSONDecoder().decode([Topic].self, from: data)
                completion(.success(topics))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Save favorite topics to UserDefaults
    func saveFavoriteTopics(_ topics: [String]) {
        if let encodedData = try? JSONEncoder().encode(topics) {
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        }
    }
    
    // Load Favorite topics from UserDefaults
    func loadFavoriteTopics() -> [String] {
        guard let savedData = UserDefaults.standard.data(forKey: favoritesKey),
              let topics = try? JSONDecoder().decode([String].self, from: savedData) else { return [] }
        return topics
    }
}
