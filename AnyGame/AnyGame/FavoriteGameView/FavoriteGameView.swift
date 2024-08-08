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
            ZStack {
                // Hintergrund hinzufügen
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.12, green: 0.12, blue: 0.12), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.15, green: 0.26, blue: 0.37), location: 1.00)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // HStack mit dem Titel
                    HStack {
                        Text("Favorite Games")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()

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
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let game = favoriteViewModel.favoriteGames[index]
                                favoriteViewModel.removeGameFromFavorites(withId: game.rawID)
                            }
                        }
                    }
                    .background(Color.clear) // Hintergrund der Liste transparent setzen, um den Gradient durchscheinen zu lassen
                    .scrollContentBackground(.hidden) // iOS 16+ spezifische Funktion, um den Listenhintergrund zu verstecken
                }
            }
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
