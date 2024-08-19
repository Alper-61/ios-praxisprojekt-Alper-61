//
//  SettingsView.swift
//  AnyGame
//
//  Created by Alper Görler on 08.07.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var name: String = ""
    @State private var nachname: String = ""
    @State private var email: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
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
                Text("Profil bearbeiten")
                    .font(
                        Font.custom("SF Pro Text", size: 24)
                            .weight(.bold)
                    )
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("Name")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    TextField("", text: $name)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }
                
                ZStack(alignment: .leading) {
                    if nachname.isEmpty {
                        Text("Nachname")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    TextField("", text: $nachname)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("E-Mail")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    TextField("", text: $email)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }

                ZStack(alignment: .leading) {
                    if currentPassword.isEmpty {
                        Text("Aktuelles Passwort")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    SecureField("", text: $currentPassword)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }
                
                ZStack(alignment: .leading) {
                    if newPassword.isEmpty {
                        Text("Neues Passwort")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    SecureField("", text: $newPassword)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }
                
                ZStack(alignment: .leading) {
                    if confirmPassword.isEmpty {
                        Text("Neues Passwort bestätigen")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    SecureField("", text: $confirmPassword)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.vertical, 5)
                }
                
                Button("Speichern") {
                    if let userId = loginViewModel.user?.id {
                        loginViewModel.updateFirestoreUser(id: userId, name: name, nachname: nachname, email: email)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .foregroundColor(.white)
                
                Spacer()
                
                Button("Abmelden") {
                    loginViewModel.logout()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .foregroundColor(.white)
            }
            .padding()
            .onAppear {
                if let user = loginViewModel.user {
                    self.name = user.name
                    self.nachname = user.nachname
                    self.email = user.email
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LoginViewModel())
}
