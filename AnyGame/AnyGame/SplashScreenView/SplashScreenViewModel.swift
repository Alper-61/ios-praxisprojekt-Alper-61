//
//  SplashScreenViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 20.08.24.
//

import SwiftUI

class SplashScreenViewModel: ObservableObject {
    @Published var isActive = false
    @Published var logoOffset: CGFloat = -UIScreen.main.bounds.width / 2 // Startet links außerhalb des Bildschirms
    @Published var rotationDegrees: Double = 0.0
    
    func onAppear() {
        animateSplashScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation {
                self.isActive = true
            }
        }
    }
    
    func animateSplashScreen() {
        withAnimation(.easeIn(duration: 1.6)) {
            self.logoOffset = 0 // Bewegt das Logo in die Mitte des Bildschirms
        }
        
        // Wackelanimation in der Mitte
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(Animation.linear(duration: 0.1).repeatCount(5, autoreverses: true)) {
                self.rotationDegrees = 10.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Animation.linear(duration: 0.1)) {
                    self.rotationDegrees = 0.0
                }
            }
        }
        
        // Bewegt das Logo nach rechts aus dem Bildschirm heraus
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation(.easeOut(duration: 1.6)) {
                self.logoOffset = UIScreen.main.bounds.width / 2
            }
        }
    }
}
