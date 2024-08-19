//
//  RegistrierenView.swift
//  AnyGame
//
//  Created by Alper Görler on 08.07.24.
//

import SwiftUI

struct RegistrierenView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    
    // MARK: VARIABLES -
    @State private var name = ""
    @State private var nachname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    
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
            
            VStack(spacing: 20) {
                Text("Neu hier? Jetzt registrieren!")
                    .font(
                        Font.custom("SF Pro Text", size: 24)
                            .weight(.bold)
                    )
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("Name")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 20)
                    }
                    TextField("", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                ZStack(alignment: .leading) {
                    if nachname.isEmpty {
                        Text("Nachname")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 20)
                    }
                    TextField("", text: $nachname)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("E-Mail")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 20)
                    }
                    TextField("", text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("Passwort")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 20)
                    }
                    SecureField("", text: $password)
                        .padding()
                        .disableAutocorrection(true) // Disable password suggestions
                        .textContentType(.oneTimeCode) // Prevent auto-suggested passwords
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                ZStack(alignment: .leading) {
                    if passwordCheck.isEmpty {
                        Text("Passwort bestätigen!")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 20)
                    }
                    SecureField("", text: $passwordCheck)
                        .padding()
                        .disableAutocorrection(true)
                        .textContentType(.oneTimeCode)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button("Registrieren!"){
                    viewModel.register(password: password, name: name, nachname: nachname, email: email, passwordCheck: passwordCheck)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .foregroundStyle(.white)
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    RegistrierenView()
        .environmentObject(LoginViewModel())
}
