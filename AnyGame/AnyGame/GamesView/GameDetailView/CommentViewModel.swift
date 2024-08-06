//
//  CommentViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 23.07.24.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private let db = Firestore.firestore()
    
    func fetchComments(gameId: Int) {
        db.collection("games").document("\(gameId)").collection("comments")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching comments: \(error)")
                    return
                }
                self.comments = snapshot?.documents.compactMap { document -> Comment? in
                    try? document.data(as: Comment.self)
                } ?? []
            }
    }
    
    func addComment(gameId: Int, text: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let newComment = Comment(
            id: nil,
            userId: user.uid,
            userName: user.displayName ?? "Unknown",
            text: text,
            timestamp: Date()
        )
        
        do {
            let documentRef = try db.collection("games").document("\(gameId)").collection("comments").addDocument(from: newComment)
            var updatedComment = newComment
            updatedComment.id = documentRef.documentID
            comments.append(updatedComment) // Update the local comments list immediately
        } catch {
            print("Error adding comment: \(error)")
        }
    }
    
    func deleteComment(gameId: Int, commentId: String) {
        db.collection("games").document("\(gameId)").collection("comments").document(commentId).delete { error in
            if let error = error {
                print("Error deleting comment: \(error)")
            } else {
                self.comments.removeAll { $0.id == commentId }
            }
        }
    }
}
