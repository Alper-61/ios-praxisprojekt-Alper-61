//
//  Extensions.swift
//  AnyGame
//
//  Created by Alper Görler on 14.08.24.
//

import SwiftUI


extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
