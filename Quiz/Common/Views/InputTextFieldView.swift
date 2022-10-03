//
//  InputTextFieldView.swift
//  Quiz
//

import SwiftUI

struct InputTextFieldView: View {
    let placeholder: String
    let errorMessage: String?
    @Binding var text: String
    
    var body: some View {
        let textField = TextField(placeholder, text: $text)
            .foregroundColor(.black)
            .textFieldDefaultStyle()
        if let errorMessage = errorMessage {
            VStack(spacing: 5) {
                textField
                
                ErrorView(message: errorMessage)
            }
        } else {
           textField
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

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient.defaultAppBackground
                .ignoresSafeArea()
            
            InputTextFieldView(placeholder: "Email",
                               errorMessage: "No email error!",
                               text: .constant("Test"))
            .keyboardType(.emailAddress)
            .padding()
        }
    }
}
