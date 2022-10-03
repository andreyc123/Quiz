//
//  QuestionButton.swift
//  Quiz
//

import SwiftUI

struct QuestionButton: View {
    let viewModel: QuestionViewModel
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    private var state: QuestionViewModel.State {
        viewModel.state
    }
    
    private var color: Color {
        state.color
    }
    
    private var mainContentView: some View {
        VStack(spacing: 6) {
            ZStack {
                Text(String(index + 1))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
            }
            .frame(width: 40, height: 40)
            .overlay {
                Circle().stroke(color, lineWidth: 1)
            }
            
            Image.getAnswerState(state)
        }
        .frame(width: 55, height: 90)
    }
    
    private var selectedMainContentView: some View {
        mainContentView.background(
            Color.white
                .shadow(color: .black.opacity(0.2),
                        radius: 2, x: 0, y: 0)
        )
    }
    
    private var currentMainContentView: some View {
        Group {
            if isSelected {
                selectedMainContentView
            } else {
                mainContentView
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            currentMainContentView
                .padding(.all, 10)
        }
    }
}

struct QuestionButton_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = QuestionViewModel(question: Question(id: 1, text: "Test question"), answers: [])
        QuestionButton(viewModel: viewModel, index: 0, isSelected: true, action: {})
    }
}
