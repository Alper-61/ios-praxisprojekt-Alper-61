//
//  SplashScreenView.swift
//  AnyGame
//
//  Created by Alper Görler on 20.08.24.
//

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var viewModel = SplashScreenViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isActive {
                Color.clear
                    .background(
                        Color.white
                    )
                    .edgesIgnoringSafeArea(.all)
            } else {
                VStack {
                    Image("AnyGame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .offset(x: viewModel.logoOffset)
                        .rotationEffect(.degrees(viewModel.rotationDegrees))
                        .onAppear {
                            viewModel.onAppear()
                        }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
