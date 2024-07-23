//
//  GamesApiRepository.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import Foundation

class GamesApiRepository {
    enum ApiError: Error {
        case invalidUrl
    }

    private var apiKey: String {
        return ApiKeys.GamesApiKey.rawValue
    }

    func fetchGames() async throws -> [GamesResponse.Game] {
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
        return gamesResponse.results
    }
    
    func searchGames(keyword: String) async throws -> [GamesResponse.Game] {
        guard let url = URL(string: "https://api.rawg.io/api/games?search=\(keyword)&key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
        return gamesResponse.results
    }

    func fetchGenres() async throws -> [Genre] {
        guard let url = URL(string: "https://api.rawg.io/api/genres?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let genresResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
        return genresResponse.results
    }

    func fetchPlatforms() async throws -> [Platform] {
        guard let url = URL(string: "https://api.rawg.io/api/platforms?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let platformsResponse = try JSONDecoder().decode(PlatformsResponse.self, from: data)
        return platformsResponse.results
    }

    func fetchPublishers() async throws -> [Publisher] {
        guard let url = URL(string: "https://api.rawg.io/api/publishers?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let publishersResponse = try JSONDecoder().decode(PublishersResponse.self, from: data)
        return publishersResponse.results
    }

    func fetchTags() async throws -> [Tag] {
        guard let url = URL(string: "https://api.rawg.io/api/tags?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let tagsResponse = try JSONDecoder().decode(TagsResponse.self, from: data)
        return tagsResponse.results
    }

    func fetchFilteredGames(genres: String, platforms: String, publishers: String, tags: String) async throws -> [GamesResponse.Game] {
        guard var urlComponents = URLComponents(string: "https://api.rawg.io/api/games") else {
            throw ApiError.invalidUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        if !genres.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "genres", value: genres))
        }
        
        if !platforms.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "platforms", value: platforms))
        }
        
        if !publishers.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "publishers", value: publishers))
        }
        
        if !tags.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "tags", value: tags))
        }
        
        guard let url = urlComponents.url else {
            throw ApiError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
        return gamesResponse.results
    }

    func fetchGameDetails(gameId: Int) async throws -> GamesResponse.Game {
        guard let url = URL(string: "https://api.rawg.io/api/games/\(gameId)?key=\(apiKey)") else {
            throw ApiError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let gameDetails = try JSONDecoder().decode(GamesResponse.Game.self, from: data)
        return gameDetails
    }
}
