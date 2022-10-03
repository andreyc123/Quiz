//
//  ErrorAlertModifier.swift
//  Quiz
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented, content: {
                Alert(title: Text("Error"),
                      message: Text(message),
                      dismissButton: .destructive(Text("OK"))
                )
            })
    }
}

extension View {
    func errorAlert(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ErrorAlertModifier(isPresented: isPresented, message: message))
    }
}
