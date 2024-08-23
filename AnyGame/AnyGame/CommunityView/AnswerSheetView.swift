//
//  AnswerSheetView.swift
//  AnyGame
//
//  Created by Alper Görler on 02.08.24.
//

import SwiftUI
import FirebaseAuth

struct AnswerSheet: View {
    @State private var answerText: String = ""
    @ObservedObject var viewModel: CommunityViewModel
    @Binding var question: Question
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.15, green: 0.26, blue: 0.37)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(question.answers) { answer in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(answer.userName)
                                        .font(.headline)
                                        .foregroundStyle(.blue) // Benutzername in Weiß
                                    Spacer()
                                    if answer.userId == Auth.auth().currentUser?.uid {
                                        Text("Du")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                Text(answer.text)
                                    .font(.body)
                                    .foregroundStyle(.white) // Antworttext in Weiß
                                
                                if answer.userId == Auth.auth().currentUser?.uid {
                                    Button(action: {
                                        viewModel.deleteAnswer(answer, from: question)
                                    }) {
                                        Text("Löschen")
                                            .foregroundStyle(.red)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            
                            Divider() // Trennlinie zwischen den Antworten
                                .background(Color.white.opacity(0.5)) // Divider in weißer Farbe mit Transparenz
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
                
                HStack {
                    TextField("Kommentieren...", text: $answerText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.addAnswer(to: question, text: answerText)
                        answerText = "" // Leere das Textfeld nach dem Senden der Antwort
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(answerText.isEmpty)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
            }
        }
    }
}

#Preview {
    @State var question = Question(id: "1", userId: "1", userName: "User", text: "Testfrage", timestamp: Date(), imageUrl: nil, answers: [
        Answer(id: "1", userId: "2", userName: "Antworter", text: "Das ist eine Antwort", timestamp: Date())
    ])

    return AnswerSheet(viewModel: CommunityViewModel(), question: $question)
}
