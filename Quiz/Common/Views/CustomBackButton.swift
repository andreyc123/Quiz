//
//  CustomBackButton.swift
//  Quiz
//

import SwiftUI

struct CustomBackButton: View {
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28.0, height: 28.0)
                .foregroundColor(color)
                .offset(x: -4, y: 0)
        }
        .frame(width: 75.0, height: 48.0)
    }
    
    init(color: Color = .white, action: @escaping () -> Void) {
        self.color = color
        self.action = action
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton(color: .black) {
        }
    }
}
