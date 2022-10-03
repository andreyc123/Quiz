//
//  Test.swift
//  Quiz
//

import SwiftUI

struct Test: Identifiable {
    let id: String
    let text: String
    let questionCount: Int
    let position: Int
}

extension Test {
    init?(id: String, dict: JSON) {
        guard let text = dict[.textKey] as? String,
              let questionCount = dict[.questionCountKey] as? Int,
              let position = dict[.positionKey] as? Int else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.questionCount = questionCount
        self.position = position
    }
}

extension Test {
    static let mock: [Test] = {
        let data: [(String, Int)] = [
            ("Easy English Conversation: “DID YOU KNOW?” or “DO YOU KNOW?”", 6),
            ("Learn English Prepositions: BY, UNTIL, TILL, ’TIL...", 8),
            ("Polite English: Modals for Advice – SHOULD, MUST, HAVE TO...", 10),
            ("Learn English Grammar: NOUN, VERB, ADVERB, ADJECTIVE", 9),
            ("Ways Meditation Will Help You Learn", 4)
        ]
        var result = [Test]()
        for (index, value) in data.enumerated() {
            result.append(Test(id: UUID().uuidString, text: value.0, questionCount: value.1, position: index + 1))
        }
        return result
    }()
}
