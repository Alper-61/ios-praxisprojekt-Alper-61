//
//  Comment.swift
//  AnyGame
//
//  Created by Alper Görler on 23.07.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let userId: String
    let userName: String
    let text: String
    let timestamp: Date

    // Equatable-Konformität
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}
