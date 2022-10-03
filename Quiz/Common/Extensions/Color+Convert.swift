//
//  Color+Utils.swift
//  Quiz

import Foundation
import SwiftUI

extension Color {
    static func from(hex: String, opacity: Double = 1.0) -> Color {
        var currentHex = hex
        if currentHex.hasPrefix("#") {
            currentHex = String(currentHex.dropFirst())
        }
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: currentHex)
        scanner.scanHexInt64(&rgbValue)
        return Color(red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
                     green: Double((rgbValue & 0xFF00) >> 8) / 255.0,
                     blue: Double(rgbValue & 0xFF) / 255.0,
                     opacity: opacity)
    }
}
