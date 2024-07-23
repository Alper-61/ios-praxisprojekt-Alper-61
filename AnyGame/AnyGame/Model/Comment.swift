//
//  Comment.swift
//  AnyGame
//
//  Created by Alper Görler on 23.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let userName: String
    let text: String
    let timestamp: Date
}
