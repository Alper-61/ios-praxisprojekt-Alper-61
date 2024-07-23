//
//  MainTabView.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GamesView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }

            FavoriteGameView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                        .foregroundColor(.white)
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(LoginViewModel())
        .environmentObject(FavoriteGameViewModel())
}
