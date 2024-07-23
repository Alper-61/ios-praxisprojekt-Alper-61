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
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if loginViewModel.isUserLoggeIn {
                MainTabView()
                    .environmentObject(loginViewModel)
                    .environmentObject(favoriteViewModel)
            } else {
                AuthentificationView()
                    .environmentObject(loginViewModel)
            }
        }
    }
}
