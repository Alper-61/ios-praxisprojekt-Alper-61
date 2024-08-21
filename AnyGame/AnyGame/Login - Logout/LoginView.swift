//
//  LoginView.swift
//  AnyGame
//
//  Created by Alper Görler on 08.07.24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    // MARK: - Variables
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false

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
                Text("Melde dich jetzt an!")
                    .font(
                        Font.custom("SF Pro Text", size: 24)
                            .weight(.bold)
                    )
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("Email")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    
                    TextField("", text: $email)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                }
                .padding(.bottom, 20)
                
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("Passwort")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    
                    SecureField("", text: $password)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                Button("Anmelden!") {
                    viewModel.login(email: email, password: password)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .foregroundColor(.white)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(viewModel.loginError ?? "Unbekannter Fehler"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.loginError) {
            showAlert = true
        }
    }
}

#Preview {
    LoginView().environmentObject(LoginViewModel())
}
