//
//  AnswersCountView.swift
//  Quiz
//

import SwiftUI

struct AnswersCountView: View {
    let isCorrect: Bool
    let count: Int
    
    var body: some View {
        let color: Color = isCorrect ? .defaultGreen : .red
        HStack {
            Image.getAnswerState(isCorrect ? .correct : .incorrect)
            
            Text(isCorrect ? "Correct" : "Incorrect")
                .font(.title2)
                .foregroundColor(color)
            
            Spacer()
            
            Text(String(count))
                .font(.title2)
                .foregroundColor(color)
        }
    }
}

struct AnswersCountView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersCountView(isCorrect: false, count: 7).padding()
    }
}
