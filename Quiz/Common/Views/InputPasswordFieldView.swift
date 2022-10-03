//
//  InputPasswordFieldView.swift
//  Quiz
//

import SwiftUI

struct InputPasswordFieldView: View {
    let placeholder: String
    let errorMessage: String?
    @Binding var text: String
    
    @State private var isShowPassword = false
    
    private var field: some View {
        Group {
            if isShowPassword {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField(placeholder, text: $text)
            }
        }
    }
    
    private var visibilityButton: some View {
        Button {
            isShowPassword.toggle()
        } label: {
            Image(systemName: isShowPassword ? "eye.slash" : "eye")
                .padding(.horizontal, 10.0)
                .foregroundColor(.black.opacity(0.75))
        }
    }
    
    var body: some View {
        let field = self.field
            .keyboardType(.default)
            .foregroundColor(.black)
            .textFieldDefaultStyle()
            .overlay(
                visibilityButton.frame(maxHeight: CGFloat.infinity),
                alignment: .trailing)
        
        if let errorMessage = errorMessage {
            VStack(spacing: 5) {
                field
                
                ErrorView(message: errorMessage)
            }
        } else {
            field
        }
    }
    
    init(placeholder: String,
         errorMessage: String? = nil,
         text: Binding<String>) {
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self._text = text
    }
}

struct InputPasswordFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordFieldView(placeholder: "Password",
                               errorMessage: "No password error!",
                               text: .constant("Test"))
        .padding()
    }
}
