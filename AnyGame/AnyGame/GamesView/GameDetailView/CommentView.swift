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
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(commentViewModel.comments.reversed(), id: \.id) { comment in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(comment.userName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if comment.userId == Auth.auth().currentUser?.uid {
                                        Text("Du")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Text(comment.text)
                                    .font(.body)
                                    .foregroundColor(.white)
                                
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
                            
                            Divider()
                                .background(Color.white.opacity(0.5))
                        }
                    }
                    .padding()
                    .onChange(of: commentViewModel.comments) {
                        withAnimation {
                            if let lastCommentId = commentViewModel.comments.last?.id {
                                proxy.scrollTo(lastCommentId, anchor: .bottom)
                            }
                        }
                    }
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
