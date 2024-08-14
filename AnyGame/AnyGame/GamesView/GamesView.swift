//
//  GamesView.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import SwiftUI

struct GamesView: View {
    @StateObject private var viewModel = GamesViewModel()
    @StateObject private var favoriteViewModel = FavoriteGameViewModel()
    @State private var showFilter = false
    @State private var selectedGame: GamesResponse.Game? = nil
    @State private var isSearching = false
    @AppStorage("apiKey") private var apiKey: String = ApiKeys.GamesApiKey.rawValue

    var body: some View {
        NavigationStack {
            ZStack {
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
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showFilter = true
                            }) {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $showFilter) {
                                FilterView(viewModel: viewModel)
                            }
                        }

                        if let error = viewModel.error {
                            Text(error)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)

                    Spacer()

                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding(.top)
                            .foregroundColor(.white)
                    } else if viewModel.error == nil {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.games) { game in
                                    HStack {
                                        if let imageUrlString = game.background_image, let imageUrl = URL(string: imageUrlString) {
                                            AsyncImage(url: imageUrl) { phase in
                                                switch phase {
                                                case .empty:
                                                    Color.gray
                                                        .frame(width: 120, height: 120)
                                                        .cornerRadius(10)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 120)
                                                        .cornerRadius(10)
                                                case .failure:
                                                    Color.red
                                                        .frame(width: 120, height: 120)
                                                        .cornerRadius(10)
                                                @unknown default:
                                                    Color.gray
                                                        .frame(width: 120, height: 120)
                                                        .cornerRadius(10)
                                                }
                                            }
                                        } else {
                                            Color.gray
                                                .frame(width: 120, height: 120)
                                                .cornerRadius(10)
                                        }

                                        VStack(alignment: .leading) {
                                            Text(game.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            if let released = game.released {
                                                Text("Released: \(released)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Text("Rating: \(game.rating, specifier: "%.2f")")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        
                                    }
                                    .padding(.vertical, 5)
                                    .background(
                                        Color.white.opacity(0.1)
                                            .cornerRadius(10)
                                    )
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        self.selectedGame = game
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationDestination(isPresented: .constant(selectedGame != nil)) {
                    if let game = selectedGame {
                        GameDetailView(gameId: game.rawID)
                            .environmentObject(favoriteViewModel)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    Text(game.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                }
                .onAppear {
                    viewModel.fetchGames()
                }
                .searchable(text: $viewModel.keyword, prompt: "Search")

                .autocorrectionDisabled(true)
                .tint(.white)
                .onSubmit(of: .search) {
                    viewModel.searchGames()
                    isSearching = true
                }
                .onChange(of: viewModel.keyword) { newValue, oldValue in
                    if newValue.isEmpty && isSearching {
                        viewModel.fetchGames()
                        viewModel.error = nil
                        isSearching = false
                    } else {
                        viewModel.searchGames()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AnyGame")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    GamesView()
}
