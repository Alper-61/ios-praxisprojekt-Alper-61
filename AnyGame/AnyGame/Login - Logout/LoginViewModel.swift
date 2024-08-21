//
//  LoginViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 08.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {

    // MARK: - Variables
    @Published private(set) var user: FireUser?
    @Published private(set) var passwordError: String?
    @Published var loginError: String?  // Variable für Login-Fehlermeldungen

    var isUserLoggeIn: Bool {
        return user != nil
    }

    private var firebaseAuthentification = Auth.auth()
    private var firebaseFirestore = Firestore.firestore()

    // Initialisierer, um den aktuellen Benutzer beim Start zu holen
    init() {
        if let currentUser = self.firebaseAuthentification.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
        }
    }

    // Funktion, um den Benutzer aus Firestore zu holen
    private func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }
            guard let document else {
                print("Document does not exist")
                return
            }
            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }

    // Funktion, um den Benutzer anzumelden
    func login(email: String, password: String) {
        firebaseAuthentification.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .wrongPassword:
                        self.loginError = "Falsches Passwort, versuchen Sie es erneut."
                    case .invalidEmail, .userNotFound:
                        self.loginError = "Falsche Email, versuchen Sie es erneut."
                    default:
                        self.loginError = "Anmeldefehler: \(error.localizedDescription)"
                    }
                } else {
                    self.loginError = "Anmeldefehler: \(error.localizedDescription)"
                }
                return
            }
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                self.loginError = "Falsche Email, versuchen Sie es erneut."
                return
            }
            print("Successfully signed in with user-Id \(authResult.user.uid) and email \(userEmail)")
            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }

    // Funktion, um den Benutzer zu registrieren
    func register(password: String, name: String, nachname: String, email: String, passwordCheck: String) {
        guard password == passwordCheck else {
            self.passwordError = "Passwörter stimmen nicht überein!"
            return
        }
        firebaseAuthentification.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error in registration: \(error)")
                return
            }
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }
            print("Successfully registered with user-Id \(authResult.user.uid) and email \(userEmail)")
            self.createFirestoreUser(id: authResult.user.uid, name: name, nachname: nachname, email: email)
            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }

    // Funktion, um den Benutzer in Firestore zu erstellen
    private func createFirestoreUser(id: String, name: String, nachname: String, email: String) {
        let newFireUser = FireUser(id: id, name: name, nachname: nachname, email: email)
        do {
            try self.firebaseFirestore.collection("users").document(id).setData(from: newFireUser)
            if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                currentUser.displayName = newFireUser.name
                currentUser.commitChanges(completion: { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("DisplayName changed")
                    }
                })
            }
        } catch {
            print("Error saving user in firestore: \(error)")
        }
    }

    // Funktion, um den Benutzer abzumelden
    func logout() {
        do {
            try firebaseAuthentification.signOut()
            self.user = nil
        } catch {
            print("Error in logout: \(error)")
        }
    }

    // Funktion, um Benutzerdaten in Firestore zu aktualisieren
    func updateFirestoreUser(id: String, name: String, nachname: String, email: String) {
        let updatedFireUser = FireUser(id: id, name: name, nachname: nachname, email: email)
        do {
            try self.firebaseFirestore.collection("users").document(id).setData(from: updatedFireUser)

            if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                currentUser.displayName = name // Update Firebase Auth DisplayName
                currentUser.commitChanges { error in
                    if let error = error {
                        print("Error updating Firebase Auth user: \(error)")
                    } else {
                        print("Firebase Auth user updated successfully")
                        self.fetchFirestoreUser(withId: id) // Refresh local user data
                    }
                }
            }
        } catch {
            print("Error updating user in firestore: \(error)")
        }
    }

    // Funktion, um das Passwort des Benutzers zu ändern
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) {
        guard newPassword == confirmPassword else {
            self.passwordError = "Neue Passwörter stimmen nicht überein!"
            return
        }

        if let user = firebaseAuthentification.currentUser, let email = user.email {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    print("Fehler bei der Re-Authentifizierung: \(error)")
                    self.passwordError = "Aktuelles Passwort ist falsch!"
                    return
                }

                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("Fehler beim Ändern des Passworts: \(error)")
                    } else {
                        print("Passwort erfolgreich geändert!")
                    }
                }
            }
        }
    }

    // Funktion, um die E-Mail des Benutzers zu aktualisieren
    func updateEmail(newEmail: String, currentPassword: String) {
        guard let user = firebaseAuthentification.currentUser else {
            print("Kein Benutzer angemeldet")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("Fehler bei der Re-Authentifizierung: \(error)")
                self.loginError = "Fehler bei der Re-Authentifizierung, bitte versuchen Sie es erneut."
                return
            }

            user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                if let error = error {
                    print("Error updating email: \(error)")
                    self.loginError = "Fehler beim Aktualisieren der E-Mail, bitte versuchen Sie es erneut."
                } else {
                    print("Email updated successfully")
                    self.updateFirestoreUser(id: user.uid, name: self.user?.name ?? "", nachname: self.user?.nachname ?? "", email: newEmail)
                }
            }
        }
    }
}
