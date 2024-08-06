//
//  MainTabView.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        // Anpassung des Erscheinungsbildes der TabBar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        // Setze die Hintergrundfarbe der TabBar auf die gleiche Farbe wie deine Views
        tabBarAppearance.backgroundColor = UIColor(Color(.systemBackground))
        
        // Farbe der inaktiven TabItems (nicht ausgewählt)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Farbe der aktiven TabItems (ausgewählt)
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemPink
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        
    }
    
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
            
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.red) // Ändert die Farbe der aktiven TabItems zu Rot
    }
}

#Preview {
    MainTabView()
        .environmentObject(LoginViewModel())
        .environmentObject(FavoriteGameViewModel())
}


