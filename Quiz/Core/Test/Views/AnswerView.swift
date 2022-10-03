//
//  AnswerView.swift
//  Quiz
//

import SwiftUI

struct AnswerView: View {
    let viewModel: AnswerViewModel
    let isDisabled: Bool
    let action: () -> Void
    
    private var opacity: Double {
        isDisabled ? Constants.disabledStateOpacity : 1.0
    }
    
    private var isCorrect: Bool {
        viewModel.answer.isCorrect
    }
    
    private var textColor: Color {
        let state: QuestionViewModel.State = isCorrect ? .correct : .incorrect
        return state.color
    }
    
    private var button: some View {
        let textColor: Color
        let borderColor: Color
        if !viewModel.isUserAnswer {
            textColor = .black
            borderColor = .gray
        } else {
            textColor = self.textColor
            borderColor = textColor
        }
        
        let cornerRadius = QuestionTitleView.cornerRadius
        let button = Button(action: action) {
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10.0, height: 10.0)
                    .foregroundColor(textColor.opacity(opacity))
                
                Text(viewModel.answer.text)
                    .font(.subheadline)
                    .foregroundColor(textColor.opacity(opacity))
            }
            .padding()
            .background(Color.defaultGray.opacity(opacity))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.15),
                    radius: 2.5, x: 0, y: 0)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 0.5)
            }
        }
        .disabled(isDisabled)
        return button
    }
    
    var body: some View {
        if !viewModel.isUserAnswer {
            button
        } else {
            HStack {
                Image.getAnswerState(isCorrect ? .correct : .incorrect)
                
                button
            }
        }
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var viewModel: AnswerViewModel {
        let viewModel = AnswerViewModel(answer: Answer(id: 1, text: "Answer", isCorrect: false))
        viewModel.isUserAnswer = true
        return viewModel
    }
    
    static var previews: some View {
        ZStack {
            LinearGradient.mainAppBackground
                .ignoresSafeArea()
            
            AnswerView(viewModel: viewModel, isDisabled: true, action: {})
        }
    }
}
