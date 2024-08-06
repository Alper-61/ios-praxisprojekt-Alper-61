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
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
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
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
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
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(game.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            if let released = game.released {
                                Text("Released: \(released)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Text("Rating: \(game.rating, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let metacritic = game.metacritic {
                                Text("Metacritic: \(metacritic)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let esrb = game.esrb_rating {
                                Text("ESRB Rating: \(esrb.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let publishers = game.publishers {
                                Text("Publishers: \(publishers.map { $0.name }.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let genres = game.genres {
                                Text("Genres: \(genres.map { $0.name }.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let platforms = game.platforms {
                                Text("Platforms: \(platforms.map { $0.platform.name }.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if let description = game.description {
                                Text(description)
                                    .padding(.top, 10)
                                    .foregroundColor(.white)
                            }
                            
                            if let redditUrl = game.reddit_url, let url = URL(string: redditUrl) {
                                Link("Reddit Discussion", destination: url)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 10)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            if favoriteViewModel.isFavorite(game: game) {
                                favoriteViewModel.removeGameFromFavorites(withId: game.rawID)
                            } else {
                                favoriteViewModel.addGameToFavorites(game: game)
                            }
                        }) {
                            if favoriteViewModel.isFavorite(game: game) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 10)
                        
                        // Kommentarbereich
                        CommentView(gameId: gameId)
                            .padding(.top, 10)
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.15, green: 0.26, blue: 0.37)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchGameDetails(gameId: gameId)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.15, green: 0.26, blue: 0.37)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    GameDetailView(gameId: 1)
        .environmentObject(FavoriteGameViewModel())
}
