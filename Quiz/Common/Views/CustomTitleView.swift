//
//  CustomTitleView.swift
//  Quiz
//

import SwiftUI

struct CustomTitleView: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.custom("Avenir", size: 24.0))
            .foregroundColor(color)
    }
    
    init(title: String, color: Color = .white) {
        self.title = title
        self.color = color
    }
}
