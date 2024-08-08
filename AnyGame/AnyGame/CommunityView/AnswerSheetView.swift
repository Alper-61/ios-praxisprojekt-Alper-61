//
//  AnswerSheetView.swift
//  AnyGame
//
//  Created by Alper Görler on 02.08.24.
//

import SwiftUI

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
                    VStack(spacing: 10) {
                        ForEach(question.answers) { answer in
                            VStack(alignment: .leading) {
                                Text(answer.userName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(answer.text)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
                
                HStack {
                    TextField("Antwort eingeben...", text: $answerText)
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
