//
//  CommentView.swift
//  AnyGame
//
//  Created by Alper Görler on 22.07.24.
//
import SwiftUI
import FirebaseAuth

struct CommentView: View {
    @State private var commentText: String = ""
    @StateObject private var commentViewModel = CommentViewModel()
    let gameId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Kommentare")
                .foregroundStyle(Color.white)
                .font(.title2)
                .padding(.bottom, 10)
            
            HStack {
                TextField("Schreibe einen Kommentar...", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !commentText.isEmpty {
                        commentViewModel.addComment(gameId: gameId, text: commentText)
                        commentText = ""
                    }
                }) {
                    Text("Posten")
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 10)
            
            List {
                ForEach(commentViewModel.comments) { comment in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(comment.userName)
                                .font(.headline)
                            Spacer()
                            if comment.userId == Auth.auth().currentUser?.uid {
                                Text("Du")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(comment.text)
                            .font(.body)
                        
                        if comment.userId == Auth.auth().currentUser?.uid {
                            Button(action: {
                                commentViewModel.deleteComment(gameId: gameId, commentId: comment.id ?? "")
                            }) {
                                Text("Löschen")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .onAppear {
            commentViewModel.fetchComments(gameId: gameId)
        }
    }
}

#Preview {
    CommentView(gameId: 1)
        .environmentObject(CommentViewModel())
}
