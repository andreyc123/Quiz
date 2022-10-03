//
//  QuestionView.swift
//  Quiz
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuestionViewModel
    
    let onChange: () -> Void
    
    private var isDisabled: Bool {
        viewModel.state != .notAnswered
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                VStack(alignment: .leading) {
                    QuestionTitleView(viewModel: viewModel, isDisabledState: isDisabled)
                        .padding(.bottom, 10)
                    
                    let answers = viewModel.answers
                    ForEach(answers.indices, id: \.self) { index in
                        let answer = answers[index]
                        AnswerView(viewModel: answer, isDisabled: isDisabled) {
                            answer.isUserAnswer = true
                            viewModel.updateState()
                            onChange()
                        }
                        .padding(.bottom, index == answers.count - 1 ? 5 : 0)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient.mainAppBackground
                .ignoresSafeArea()
            
            let answers = [
                Answer(id: 1, text: "Answer 1", isCorrect: true),
                Answer(id: 2, text: "Answer 2", isCorrect: false)]
            let viewModel = QuestionViewModel(question: Question(id: 1, text: "Test question"), answers: answers.map(AnswerViewModel.init))
            QuestionView(viewModel: viewModel) {}
        }
    }
}
