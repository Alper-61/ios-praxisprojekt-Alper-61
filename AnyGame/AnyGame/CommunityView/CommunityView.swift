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
    @State private var selectedQuestionIndex: Int? = nil
    
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
                            ForEach(viewModel.questions, id: \.id) { question in
                                VStack(alignment: .leading) {
//                                    let question = viewModel.questions[index]
                                    
                                    // Bild anzeigen, wenn imageUrl vorhanden ist
                                    if let imageUrl = question.imageUrl, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 200)
                                            case .success(let image):
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 200)
                                                    .clipped()
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 200)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 200)
                                                    .foregroundColor(.gray)
                                            }
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
                                            // resimler karışık geliyordu id değerleri eşit gelsin diye böyle bir kod yazdım
                                            selectedQuestionIndex =  viewModel.questions.firstIndex(where: { $0.id == question.id })
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
            .sheet(isPresented: Binding<Bool>(
                get: { selectedQuestionIndex != nil },
                set: { if !$0 { selectedQuestionIndex = nil } }
            )) {
                if let selectedQuestionIndex = selectedQuestionIndex {
                    AnswerSheet(viewModel: viewModel, question: $viewModel.questions[selectedQuestionIndex])
                }
            }
            .sheet(isPresented: $showingAddQuestionSheet) {
                AddQuestionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchQuestions()
            }
        }
        .padding(.bottom, 20)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.15, green: 0.26, blue: 0.37)]), startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    CommunityView()
}
