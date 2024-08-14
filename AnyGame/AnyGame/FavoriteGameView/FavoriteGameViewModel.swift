//
//  FavoriteGameViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FavoriteGameViewModel: ObservableObject {
    @Published var favoriteGames: [GamesResponse.Game] = []
    
    private let firebaseAuth = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?

    func addGameToFavorites(game: GamesResponse.Game) {
        guard let userId = firebaseAuth.currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let newFavoriteGame = game
        do {
            try firebaseFirestore.collection("users").document(userId).collection("favorites").document(String(game.rawID)).setData(from: newFavoriteGame)
            print("Game added to favorites")

            self.favoriteGames.append(newFavoriteGame) // Update local state
        } catch {
            print("Error adding game to favorites: \(error)")
        }
    }

    func fetchFavoriteGames() {
        guard let userId = firebaseAuth.currentUser?.uid else {
            print("User not logged in")
            return
        }

        self.listener = firebaseFirestore.collection("users").document(userId).collection("favorites")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching favorite games: \(error)")
                    return
                }
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }
                let favoriteGames = snapshot.documents.compactMap { document -> GamesResponse.Game? in
                    do {
                        return try document.data(as: GamesResponse.Game.self)
                    } catch {
                        print("Error decoding game: \(error)")
                    }
                    return nil
                }
                self.favoriteGames = favoriteGames
            }
    }

    func removeGameFromFavorites(withId id: Int) {
        guard let userId = firebaseAuth.currentUser?.uid else {
            print("User not logged in")
            return
        }

        firebaseFirestore.collection("users").document(userId).collection("favorites").document(String(id)).delete { [self] error in
            if let error = error {
                print("Error removing game from favorites: \(error)")
            } else {
                self.favoriteGames.removeAll { $0.rawID == id } // Update local state
            }
        }
    }
    
    func isFavorite(game: GamesResponse.Game) -> Bool {
        print("gelen id \(game.rawID)")
        return favoriteGames.contains { $0.rawID == game.rawID }
    }
    
    func toggleFavoriteStatus(for game: GamesResponse.Game) {
        if isFavorite(game: game) {
            removeGameFromFavorites(withId: game.rawID)
        } else {
            addGameToFavorites(game: game)
        }
    }
}
