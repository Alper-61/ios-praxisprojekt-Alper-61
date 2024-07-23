//
//  AuthentificationView.swift
//  AnyGame
//
//  Created by Alper Görler on 08.07.24.
//

import SwiftUI

struct AuthentificationView: View {
    
    // MARK: Variables -
    @State private var anmelden = false
    @State private var registrieren = false
    
    var body: some View {
        ZStack {
            // Hintergrund mit Farbverlauf
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
                // Logo
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 183, height: 184)
                    .background(
                        Image("AnyGame")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 183, height: 184)
                            .clipped()
                    )
                    .cornerRadius(25)
                    .shadow(color: Color(red: 1, green: 1, blue: 1).opacity(0.25), radius: 1.9, x: -4, y: 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .inset(by: -0.5)
                            .stroke(Constants.primr, lineWidth: 1)
                    )
                    .padding(30)
                
                // Willkommen Text
                Text("Willkommen zu AnyGame")
                    .font(
                        Font.custom("SF Pro Text", size: 24)
                            .weight(.bold)
                            .italic()
                    )
                    .underline()
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                // Anmelden Button
                Button("Anmelden") {
                    anmeldenToggle()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // Registrieren Button
                Button("Registrieren") {
                    registrierenToggle()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding()
        }
        .sheet(isPresented: $anmelden) {
            NavigationStack {
                LoginView()
                    .navigationBarItems(trailing: Button(action: {
                        anmelden.toggle()
                    }) {
                        Image(systemName: "xmark")
                    })
            }
        }
        .sheet(isPresented: $registrieren) {
            NavigationStack {
                RegistrierenView()
                    .navigationBarItems(trailing: Button(action: {
                        registrieren.toggle()
                    }) {
                        Image(systemName: "xmark")
                    })
            }
        }
    }
    
    // MARK: Functions -
    func anmeldenToggle() {
        anmelden.toggle()
    }
    
    func registrierenToggle() {
        registrieren.toggle()
    }
}

struct Constants {
    static let primr: Color = .white
}

#Preview {
    AuthentificationView()
}







