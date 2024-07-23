//
//  CommentViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 23.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private let db = Firestore.firestore()
    
    func fetchComments(gameId: Int) {
        db.collection("games").document("\(gameId)").collection("comments").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Keine Dokumente gefunden: \(error?.localizedDescription ?? "Unbekannter Fehler")")
                return
            }
            
            self.comments = documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
        }
    }
    
    func addComment(gameId: Int, text: String) {
        guard let user = Auth.auth().currentUser else { return }
        let comment = Comment(id: UUID().uuidString, userId: user.uid, userName: user.displayName ?? "Unknown", text: text, timestamp: Date())
        
        do {
            try db.collection("games").document("\(gameId)").collection("comments").document(comment.id!).setData(from: comment)
        } catch {
            print("Fehler beim Hinzufügen des Kommentars: \(error.localizedDescription)")
        }
    }
    
    func deleteComment(gameId: Int, commentId: String) {
        db.collection("games").document("\(gameId)").collection("comments").document(commentId).delete { error in
            if let error = error {
                print("Fehler beim Löschen des Kommentars: \(error.localizedDescription)")
            }
        }
    }
}
