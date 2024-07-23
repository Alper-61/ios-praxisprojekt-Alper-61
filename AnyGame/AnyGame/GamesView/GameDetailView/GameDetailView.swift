//
//  GameDetailView.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import SwiftUI

struct GameDetailView: View {
    @StateObject private var viewModel = GameDetailViewModel()
    @EnvironmentObject private var favoriteViewModel: FavoriteGameViewModel
    let gameId: Int

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let game = viewModel.game {
                ScrollView {
                    VStack(alignment: .leading) {
                        if let imageUrlString = game.background_image, let imageUrl = URL(string: imageUrlString) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                        .frame(height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                case .failure:
                                    Color.red
                                        .frame(height: 200)
                                @unknown default:
                                    Color.gray
                                        .frame(height: 200)
                                }
                            }
                        } else {
                            Color.gray
                                .frame(height: 200)
                        }
                        
                        Text(game.name)
                            .font(.largeTitle)
                            .padding(.bottom, 10)
                        
                        if let released = game.released {
                            Text("Released: \(released)")
                                .font(.subheadline)
                        }
                        
                        Text("Rating: \(game.rating, specifier: "%.2f")")
                            .font(.subheadline)
                        
                        if let metacritic = game.metacritic {
                            Text("Metacritic: \(metacritic)")
                                .font(.subheadline)
                        }
                        
                        if let esrb = game.esrb_rating {
                            Text("ESRB Rating: \(esrb.name)")
                                .font(.subheadline)
                        }
                        
                        if let publishers = game.publishers {
                            Text("Publishers: \(publishers.map { $0.name }.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        
                        if let genres = game.genres {
                            Text("Genres: \(genres.map { $0.name }.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        
                        if let platforms = game.platforms {
                            Text("Platforms: \(platforms.map { $0.platform.name }.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        
                        if let description = game.description {
                            Text(description)
                                .padding(.top, 10)
                        }
                        
                        if let redditUrl = game.reddit_url, let url = URL(string: redditUrl) {
                            Link("Reddit Discussion", destination: url)
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if favoriteViewModel.isFavorite(game: game) {
                                favoriteViewModel.removeGameFromFavorites(withId: game.rawID)
                            } else {
                                favoriteViewModel.addGameToFavorites(game: game)
                            }
                        }) {
                            Image(systemName: favoriteViewModel.isFavorite(game: game) ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                        .padding(.top, 10)
                        
                        // Kommentarbereich
                        CommentView(gameId: gameId)
                            .padding(.top, 10)
                    }
                    .padding()
                }
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchGameDetails(gameId: gameId)
        }
    }
}

#Preview {
    GameDetailView(gameId: 1)
        .environmentObject(FavoriteGameViewModel())
}
