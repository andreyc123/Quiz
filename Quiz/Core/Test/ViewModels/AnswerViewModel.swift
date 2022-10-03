//
//  AnswerViewModel.swift
//  Quiz
//

import SwiftUI

final class AnswerViewModel: ObservableObject, Identifiable {
    let answer: Answer
    
    @Published var isUserAnswer = false
    
    var id: Int { answer.id }
    
    init(answer: Answer) {
        self.answer = answer
    }
}
