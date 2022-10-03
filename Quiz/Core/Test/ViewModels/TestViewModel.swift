//
//  TestViewModel.swift
//  Quiz
//

import SwiftUI
import Combine

final class TestViewModel: ObservableObject {
    let testId: String
    let apiClient: ApiClient
    
    @Published var questions: [QuestionViewModel] = []
    @Published var state: GeneralViewState = .undefined
    @Published var responsesPercentage: Double = 0.0
    @Published var currentQuestionIndex = 0
    @Published var alert = false
    @Published var isStatisticsShowing = false
    
    var answeredQuestionCount: Int {
        questions.reduce(0) { $0 + ($1.state.isAnswered ? 1 : 0) }
    }
    
    var numberOfCorrectAnswers: Int {
        questions.reduce(0) { $0 + ($1.state == .correct ? 1 : 0) }
    }
    
    var currentStep: Int {
        return !questions.isEmpty ? currentQuestionIndex + 1 : 0
    }
    
    var currentQuestionState: QuestionViewModel.State {
        currentQuestionIndex < questions.count ? questions[currentQuestionIndex].state : .notAnswered
    }
    
    private var subscription: AnyCancellable?
    
    init(testId: String, apiClient: ApiClient) {
        self.testId = testId
        self.apiClient = apiClient
    }
    
    func getTestQuestions() {
        guard !testId.isEmpty else {
            return
        }
        
        state = .progressIndicator
        subscription = apiClient.getTestQuestions(id: testId)
            .sink { [weak self] completion in
                self?.subscription?.cancel()
                self?.subscription = nil
                
                switch completion {
                case.finished:
                    self?.state = .success
                case .failure(let error):
                    self?.state = .error(error)
                    self?.alert = true
                }
            } receiveValue: { [weak self] questions in
                self?.questions = questions.map {
                    QuestionViewModel(question: $0.question,
                                      answers: $0.answers.map(AnswerViewModel.init))
                }
                self?.calculateResponsesPercentage()
            }
    }
    
    func update() {
        guard !questions.isEmpty else {
            return
        }
        
        calculateResponsesPercentage()
        
        let duration: Double = 0.6
        let initialPos = currentQuestionIndex
        let time: DispatchTime = .now() + .milliseconds(Int(duration * 1000))
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            guard let strongSelf = self else {
                return
            }
         
            var i = strongSelf.currentQuestionIndex
            repeat {
                if i < strongSelf.questions.count - 1 {
                    i += 1
                } else {
                    i = 0
                }
            } while i != strongSelf.currentQuestionIndex && strongSelf.questions[i].state != .notAnswered
            if i != strongSelf.currentQuestionIndex {
                if strongSelf.currentQuestionIndex == initialPos {
                    strongSelf.currentQuestionIndex = i
                }
            } else {
                let time: DispatchTime = .now() + .milliseconds(500)
                DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
                    self?.isStatisticsShowing = true
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func calculateResponsesPercentage() {
        let count = Double(questions.count)
        let f = count > 0.0 ? Double(answeredQuestionCount) / Double(count) : 0.0
        responsesPercentage = f * 100.0
    }
}
