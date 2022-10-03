//
//  Answer.swift
//  Quiz
//

import Foundation

struct Answer {
    let id: Int
    let text: String
    let isCorrect: Bool
}

extension Answer {
    init?(id: Int, dict: JSON) {
        guard let text = dict[.textKey] as? String,
              let isCorrect = dict[.isCorrectKey] as? Bool else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.isCorrect = isCorrect
    }
}
