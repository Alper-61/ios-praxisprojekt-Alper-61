//
//  AnyGameApp.swift
//  AnyGame
//
//  Created by Alper Görler on 01.07.24.
//

import Firebase
import FirebaseAuth
import SwiftUI

@main
struct AnyGameApp: App {
    
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var favoriteViewModel = FavoriteGameViewModel()
    @StateObject var communityViewModel = CommunityViewModel() // Hinzufügen des CommunityViewModel
    @State private var showSplash = true
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            withAnimation {
                                self.showSplash = false
                            }
                        }
                    }
            } else {
                if loginViewModel.isUserLoggeIn {
                    MainTabView()
                        .environmentObject(loginViewModel)
                        .environmentObject(favoriteViewModel)
                        .environmentObject(communityViewModel) // EnvironmentObject für die CommunityViewModel bereitstellen
                } else {
                    AuthentificationView()
                        .environmentObject(loginViewModel)
                }
            }
        }
    }
}
