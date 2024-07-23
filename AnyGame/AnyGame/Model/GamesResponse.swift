//
//  GamesResponse.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import Foundation

struct GamesResponse: Codable {
    let results: [Game]

    struct Game: Codable, Identifiable {
        var id: Int { rawID }
        let rawID: Int
        let name: String
        let released: String?
        let background_image: String?
        let rating: Double
        let description: String?
        let metacritic: Int?
        let reddit_url: String?
        let platforms: [PlatformWrapper]?
        let esrb_rating: EsrbRating?
        let publishers: [Publisher]?
        let genres: [Genre]?

        enum CodingKeys: String, CodingKey {
            case rawID = "id"
            case name
            case released
            case background_image
            case rating
            case description
            case metacritic
            case reddit_url
            case platforms
            case esrb_rating
            case publishers
            case genres
        }
    }
}

struct Genre: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GenresResponse: Codable {
    let results: [Genre]
}

struct Platform: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    
    static func == (lhs: Platform, rhs: Platform) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PlatformWrapper: Codable, Identifiable {
    var id: Int { platform.id }
    let platform: Platform
    
    struct Platform: Codable {
        let id: Int
        let name: String
    }
}

struct PlatformsResponse: Codable {
    let results: [Platform]
}

struct Publisher: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    
    static func == (lhs: Publisher, rhs: Publisher) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PublishersResponse: Codable {
    let results: [Publisher]
}

struct Tag: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TagsResponse: Codable {
    let results: [Tag]
}

struct EsrbRating: Codable {
    let id: Int
    let slug: String
    let name: String
}
