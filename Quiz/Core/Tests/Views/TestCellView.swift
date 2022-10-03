//
//  TestCellView.swift
//  Quiz
//

import SwiftUI

struct TestCellView: View {
    let test: Test
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                Image(systemName: "text.book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28.0, height: 28.0)
                    .padding(.top, 6)
                    .foregroundColor(.black.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(test.text)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text("\(test.questionCount) questions")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28.0, height: 28.0)
                    .padding(.top, 6)
                    .foregroundColor(.black.opacity(0.8))
            }
        }
    }
}

struct TestCellView_Previews: PreviewProvider {
    static var previews: some View {
        TestCellView(test: Test.mock.first!, action: {})
            .padding()
    }
}
