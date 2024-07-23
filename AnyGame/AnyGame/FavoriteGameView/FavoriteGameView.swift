//
//  FavoriteGameView.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import SwiftUI

struct FavoriteGameView: View {
    @EnvironmentObject private var favoriteViewModel: FavoriteGameViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(favoriteViewModel.favoriteGames) { game in
                    NavigationLink(destination: GameDetailView(gameId: game.rawID)) {
                        HStack {
                            if let imageUrlString = game.background_image, let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        Color.gray
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    case .failure:
                                        Color.red
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    @unknown default:
                                        Color.gray
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    }
                                }
                            } else {
                                Color.gray
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                            }

                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                if let released = game.released {
                                    Text("Released: \(released)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Button(action: {
                                favoriteViewModel.removeGameFromFavorites(withId: game.rawID)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite Games")
            .onAppear {
                favoriteViewModel.fetchFavoriteGames()
            }
        }
    }
}

#Preview {
    FavoriteGameView()
        .environmentObject(FavoriteGameViewModel())
}
