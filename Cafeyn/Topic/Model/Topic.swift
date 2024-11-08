//
//  Topic.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 02/11/2024.
//

import Foundation

struct Topic: Identifiable, Decodable {
    let id: String
    let name: TopicName
    let color: String
    let subTopics: [Topic]?
}

struct TopicName: Decodable {
    let raw: String
    let key: String
}

