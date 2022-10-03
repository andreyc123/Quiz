//
//  ButtonView.swift
//  Quiz
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: CGFloat.infinity)
            .background(Color.defaultGray.opacity(isDisabled || configuration.isPressed ? 0.5 : 1.0))
            .foregroundColor(Color.black.opacity(isDisabled || configuration.isPressed ? 0.4 : 0.7))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.15),
                    radius: 6.0, x: 0, y: 3)
    }
    
    init(isDisabled: Bool = false) {
        self.isDisabled = isDisabled
    }
}

struct ButtonView: View {
    let title: String
    let isDisabled: Bool
    let isProgressIndicator: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            let text = Text(title)
            if isProgressIndicator {
                HStack(spacing: 7) {
                    ProgressView()
                    
                    text
                }
            } else {
                text
            }
        }
        .buttonStyle(DefaultButtonStyle(isDisabled: isDisabled))
    }
    
    init(title: String,
         isDisabled: Bool = false,
         isProgressIndicator: Bool = false,
         action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.isProgressIndicator = isProgressIndicator
        self.action = action
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient.defaultAppBackground
                .ignoresSafeArea()
            
            ButtonView(title: "Login", isProgressIndicator: true, action: {})
                .padding()
        }
    }
}
