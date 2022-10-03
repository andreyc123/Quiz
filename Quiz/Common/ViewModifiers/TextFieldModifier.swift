//
//  TextFieldModifier.swift
//  Quiz
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.75))
                    .shadow(color: Color.black.opacity(0.15),
                            radius: 5.0, x: 0, y: 0)
            )
    }
}

extension View {
    func textFieldDefaultStyle() -> some View {
        self.modifier(TextFieldModifier())
    }
}
