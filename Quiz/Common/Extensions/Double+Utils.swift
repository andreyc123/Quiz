//
//  Double+Utils.swift
//  Quiz
//

import Foundation

extension Double {
    var asPercentString: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "%"
    }
}
