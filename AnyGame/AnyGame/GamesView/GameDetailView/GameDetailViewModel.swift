//
//  GameDetailViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import Foundation

class GameDetailViewModel: ObservableObject {
    @Published var game: GamesResponse.Game?
    @Published var isLoading = false
    @Published var error: String?

    private let repository = GamesApiRepository()

    @MainActor
    func fetchGameDetails(gameId: Int) {
        isLoading = true
        error = nil
        Task {
            do {
                let gameDetails = try await repository.fetchGameDetails(gameId: gameId)
                self.game = gameDetails
                self.isLoading = false
            } catch {
                self.error = "An API error occurred while fetching game details."
                self.isLoading = false
            }
        }
    }
}

