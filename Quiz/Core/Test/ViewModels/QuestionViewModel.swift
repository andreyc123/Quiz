//
//  QuestionViewModel.swift
//  Quiz
//

import SwiftUI

final class QuestionViewModel: ObservableObject {
    enum State {
        case notAnswered
        case correct
        case incorrect
        
        var isAnswered: Bool {
            switch self {
            case .notAnswered:
                return false
            case .correct, .incorrect:
                return true
            }
        }
        
        var systemName: String {
            switch self {
            case .notAnswered:
                return "questionmark.circle"
            case .correct:
                return "checkmark.circle"
            case .incorrect:
                return "xmark.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .notAnswered:
                return .gray
            case .correct:
                return .defaultGreen
            case .incorrect:
                return .red
            }
        }
    }
    
    let question: Question
    
    @Published var answers: [AnswerViewModel]
    @Published var state: State = .notAnswered
    
    init(question: Question, answers: [AnswerViewModel]) {
        self.question = question
        self.answers = answers
    }
    
    func updateState() {
        if let answer = answers.first(where: { $0.isUserAnswer }) {
            state = answer.answer.isCorrect ? .correct : .incorrect
        } else {
            state = .notAnswered
        }
    }
}
