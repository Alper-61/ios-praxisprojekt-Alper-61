//
//  CommunityViewModel.swift
//  AnyGame
//
//  Created by Alper Görler on 22.07.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CommunityViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var selectedImage: UIImage? = nil
    @Published var isLoading = false
    @Published var error: String?

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func fetchQuestions() {
        db.collection("questions")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    self.error = "Error fetching questions: \(error.localizedDescription)"
                    return
                }
                self.questions = snapshot?.documents.compactMap { document -> Question? in
                    let question = try? document.data(as: Question.self)
                    if let question = question {
                        self.fetchAnswers(for: question) { answers in
                            if let index = self.questions.firstIndex(where: { $0.id == question.id }) {
                                self.questions[index].answers = answers
                            }
                        }
                    }
                    return question
                } ?? []
            }
    }
    
    func addQuestion(text: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        var newQuestion = Question(
            id: nil,
            userId: user.uid,
            userName: user.displayName ?? "Unknown",
            text: text,
            timestamp: Date(),
            imageUrl: nil,
            answers: []
        )
        
        if let selectedImage = selectedImage {
            uploadImage(image: selectedImage) { url in
                newQuestion.imageUrl = url?.absoluteString
                self.saveQuestionToFirestore(newQuestion)
            }
        } else {
            saveQuestionToFirestore(newQuestion)
        }
    }
    
    private func saveQuestionToFirestore(_ question: Question) {
        do {
            let documentRef = try db.collection("questions").addDocument(from: question)
            var updatedQuestion = question
            updatedQuestion.id = documentRef.documentID
            questions.append(updatedQuestion)
        } catch {
            print("Error adding question: \(error)")
        }
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    
    func deleteQuestion(_ question: Question) {
        guard let questionId = question.id else { return }
        db.collection("questions").document(questionId).delete { error in
            if let error = error {
                print("Error deleting question: \(error)")
            } else {
                self.questions.removeAll { $0.id == question.id }
            }
        }
    }

    func fetchAnswers(for question: Question, completion: @escaping ([Answer]) -> Void) {
        guard let questionId = question.id else { return }
        db.collection("questions").document(questionId).collection("answers")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.error = "Error fetching answers: \(error.localizedDescription)"
                    completion([])
                    return
                }
                let answers = snapshot?.documents.compactMap { document -> Answer? in
                    try? document.data(as: Answer.self)
                } ?? []
                completion(answers)
            }
    }
    
    func addAnswer(to question: Question, text: String) {
        guard let user = Auth.auth().currentUser else { return }
        guard let questionId = question.id else { return }
        
        let newAnswer = Answer(
            id: nil,
            userId: user.uid,
            userName: user.displayName ?? "Unknown",
            text: text,
            timestamp: Date()
        )
        
        do {
            let documentRef = try db.collection("questions").document(questionId).collection("answers").addDocument(from: newAnswer)
            var updatedAnswer = newAnswer
            updatedAnswer.id = documentRef.documentID
            if let index = questions.firstIndex(where: { $0.id == questionId }) {
                questions[index].answers.insert(updatedAnswer, at: 0) // Füge die Antwort oben hinzu
                questions[index] = questions[index] // Aktualisiere die Frage
            }
        } catch {
            print("Error adding answer: \(error)")
        }
    }
}
