//
//  Question.swift
//  AnyGame
//
//  Created by Alper Görler on 02.08.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Question: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let userName: String
    let text: String
    let timestamp: Date
    var imageUrl: String?
    var answers: [Answer] = []
}

struct Answer: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let userName: String
    let text: String
    let timestamp: Date
}

