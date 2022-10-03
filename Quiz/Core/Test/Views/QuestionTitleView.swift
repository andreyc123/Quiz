//
//  QuestionTitleView.swift
//  Quiz
//

import SwiftUI

struct QuestionTitleView: View {
    var viewModel: QuestionViewModel
    let isDisabledState: Bool
    
    private var opacity: Double {
        isDisabledState ? Constants.disabledStateOpacity : 1.0
    }
    
    var body: some View {
        Text(viewModel.question.text)
            .font(.headline)
            .foregroundColor(.black.opacity(opacity))
            .padding()
            .background(.white.opacity(opacity))
            .clipShape(RoundedRectangle(cornerRadius: Self.cornerRadius))
            .shadow(color: .black.opacity(0.15),
                    radius: 2.5, x: 0, y: 0)
            .overlay {
                RoundedRectangle(cornerRadius: Self.cornerRadius)
                    .stroke(.gray, lineWidth: 0.5)
            }
    }
    
    static let cornerRadius = 8.0
}

struct QuestionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient.mainAppBackground
                .ignoresSafeArea()
            
            let viewModel = QuestionViewModel(question: Question(id: 1, text: "Test question"), answers: [])
            QuestionTitleView(viewModel: viewModel, isDisabledState: false)
        }
    }
}
