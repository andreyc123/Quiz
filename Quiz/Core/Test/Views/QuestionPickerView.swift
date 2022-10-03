//
//  QuestionPickerView.swift
//  Quiz
//

import SwiftUI

struct QuestionPickerView: View {
    var questions: [QuestionViewModel]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            ScrollViewReader { value in
                HStack(spacing: 0) {
                    ForEach(questions.indices, id: \.self) { index in
                        QuestionButton(viewModel: questions[index], index: index, isSelected: index == selectedIndex) {
                            selectedIndex = index
                        }
                        .id(index)
                    }
                    .onChange(of: selectedIndex) { newSelectedIndex in
                        withAnimation {
                            value.scrollTo(newSelectedIndex)
                        }
                    }
                }
            }
        }
        .frame(height: 110.0)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.15),
                        radius: 2.5, x: 0, y: -2)
        )
    }
}

struct QuestionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            LinearGradient.mainAppBackground
                .ignoresSafeArea()
            
            let questions: [QuestionViewModel] = (0..<10).map {
                QuestionViewModel(question: Question(id: $0 + 1, text: "Test question"), answers: [])
            }
            QuestionPickerView(questions: questions, selectedIndex: .constant(0))
        }
    }
}
