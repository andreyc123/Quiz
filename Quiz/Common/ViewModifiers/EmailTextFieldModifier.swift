//
//  EmailTextFieldModifier.swift
//  Quiz
//

import SwiftUI

struct EmailTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func textFieldEmailStyle() -> some View {
        self.modifier(EmailTextFieldModifier())
    }
}
