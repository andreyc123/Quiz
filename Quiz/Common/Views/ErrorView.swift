//
//  ErrorView.swift
//  Quiz
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "exclamationmark.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
                .foregroundColor(.white)
                .padding(.all, 10)
            
            Text(message)
                .foregroundColor(.white)
                .padding(.vertical, 5.0)
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.red)
        )
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Test error message").padding()
    }
}
