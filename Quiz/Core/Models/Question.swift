//
//  Question.swift
//  Quiz
//

import Foundation

struct Question {
    let id: Int
    let text: String
}

extension Question {
    init?(id: Int, dict: JSON) {
        guard let text = dict[.textKey] as? String else {
            return nil
        }
        
        self.id = id
        self.text = text
    }
}
