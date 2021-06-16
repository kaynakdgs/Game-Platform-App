//
//  PlatformResponse.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 30.05.2021.
//

import Foundation

// MARK: - Platforms
struct PlatformResponse: Decodable {
    let count: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Decodable {
    let id: Int?
    let name, slug: String?
    let platforms: [Platform]?
}

// MARK: - Platform
struct Platform: Decodable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let yearStart: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case yearStart = "year_start"
    }
}

