//
//  LinearGradient+Utils.swift
//  Quiz
//

import SwiftUI

extension LinearGradient {
    static var defaultAppBackground: LinearGradient {
        LinearGradient(colors: [.from(hex: "398AE5"), Color(red: 0.95, green: 0.95, blue: 0.95)],
                       startPoint: .top,
                       endPoint: .bottom)
    }
    
    static var mainAppBackground: LinearGradient {
        LinearGradient(colors: [Color.from(hex: "c9c9cb"), .white],
                       startPoint: .top,
                       endPoint: .bottom)
    }
}
