//
//  CommunityView.swift
//  AnyGame
//
//  Created by Alper Görler on 22.07.24.
//

import SwiftUI
import FirebaseAuth

struct CommunityView: View {
    @StateObject private var viewModel = CommunityViewModel()
    @State private var showingAddQuestionSheet = false
    @State private var selectedQuestion: Question? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.12, green: 0.12, blue: 0.12), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.15, green: 0.26, blue: 0.37), location: 1.00)
                        ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Community")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            showingAddQuestionSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.questions) { question in
                                VStack(alignment: .leading) {
                                    if let imageUrl = question.imageUrl {
                                        AsyncImage(url: URL(string: imageUrl)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 200)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    
                                    Text(question.text)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    if let latestAnswer = question.answers.first {
                                        Divider()
                                        Text("Neueste Antwort:")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(latestAnswer.text)
                                            .font(.body)
                                            .foregroundColor(.white)
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            selectedQuestion = question
                                        }) {
                                            Image(systemName: "message")
                                                .foregroundColor(.blue)
                                            Text("Antworten")
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.top, 5)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                                .contextMenu {
                                    if Auth.auth().currentUser?.uid == question.userId {
                                        Button(role: .destructive) {
                                            viewModel.deleteQuestion(question)
                                        } label: {
                                            Label("Löschen", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showingAddQuestionSheet) {
                AddQuestionView(viewModel: viewModel)
            }
            .sheet(item: $selectedQuestion) { question in
                AnswerSheet(viewModel: viewModel, question: question)
            }
            .onAppear {
                viewModel.fetchQuestions()
            }
        }
    }
}

#Preview {
    CommunityView()
}
