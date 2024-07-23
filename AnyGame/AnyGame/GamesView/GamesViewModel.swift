//
//  GamesViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import Foundation

class GamesViewModel: ObservableObject {
    @Published var games: [GamesResponse.Game] = []
    @Published var isLoading = false
    @Published var keyword: String = ""
    @Published var error: String?
    @Published var genres: [Genre] = []
    @Published var selectedGenres: [Genre] = []
    @Published var platforms: [Platform] = []
    @Published var selectedPlatforms: [Platform] = []
    @Published var publishers: [Publisher] = []
    @Published var selectedPublishers: [Publisher] = []
    @Published var tags: [Tag] = []
    @Published var selectedTags: [Tag] = []

    private let repository = GamesApiRepository()

    @MainActor
    func fetchGames() {
        isLoading = true
        error = nil
        Task {
            do {
                let games = try await repository.fetchGames()
                self.games = games
                self.isLoading = false
                self.fetchGenres()
                self.fetchPlatforms()
                self.fetchPublishers()
                self.fetchTags()
            } catch {
                self.error = "An API error occurred. Please check your API key."
                self.isLoading = false
            }
        }
    }

    @MainActor
    func searchGames() {
        isLoading = true
        error = nil
        Task {
            do {
                let games = try await repository.searchGames(keyword: keyword)
                self.games = games
                self.isLoading = false
            } catch {
                self.error = "An API error occurred. Please check your API key."
                self.isLoading = false
            }
        }
    }

    @MainActor
    func fetchGenres() {
        Task {
            do {
                let genres = try await repository.fetchGenres()
                self.genres = genres
            } catch {
                self.error = "An API error occurred while fetching genres."
            }
        }
    }

    @MainActor
    func fetchPlatforms() {
        Task {
            do {
                let platforms = try await repository.fetchPlatforms()
                self.platforms = platforms
            } catch {
                self.error = "An API error occurred while fetching platforms."
            }
        }
    }

    @MainActor
    func fetchPublishers() {
        Task {
            do {
                let publishers = try await repository.fetchPublishers()
                self.publishers = publishers
            } catch {
                self.error = "An API error occurred while fetching publishers."
            }
        }
    }

    @MainActor
    func fetchTags() {
        Task {
            do {
                let tags = try await repository.fetchTags()
                self.tags = tags
            } catch {
                self.error = "An API error occurred while fetching tags."
            }
        }
    }

    @MainActor
    func applyFilters() {
        isLoading = true
        error = nil
        Task {
            do {
                let genreIds = selectedGenres.map { String($0.id) }.joined(separator: ",")
                let platformIds = selectedPlatforms.map { String($0.id) }.joined(separator: ",")
                let publisherIds = selectedPublishers.map { String($0.id) }.joined(separator: ",")
                let tagIds = selectedTags.map { String($0.id) }.joined(separator: ",")

                let games = try await repository.fetchFilteredGames(genres: genreIds, platforms: platformIds, publishers: publisherIds, tags: tagIds)
                self.games = games
                self.isLoading = false
            } catch {
                self.error = "An API error occurred while applying filters."
                self.isLoading = false
            }
        }
    }
}






