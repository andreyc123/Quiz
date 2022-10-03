//
//  Image+Utils.swift
//  Quiz
//

import SwiftUI

extension Image {
    static func getAnswerState(_ state: QuestionViewModel.State) -> some View {
        Image(systemName: state.systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30.0, height: 30.0)
            .foregroundColor(state.color)
    }
}
