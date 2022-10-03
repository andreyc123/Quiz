//
//  String+Validation.swift
//  Quiz
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    var isStrongPassword: Bool {
        guard self.count >= Constants.minAllowedPasswordSymbols else {
            return false
        }
        
        var isLowercasedCharacter = false
        var isUppercasedCharacter = false
        var isDigitCharacter = false
        for c in self {
            if c.isLowercase {
                isLowercasedCharacter = true
            } else if c.isUppercase {
                isUppercasedCharacter = true
            } else if ("0"..."9").contains(c) {
                isDigitCharacter = true
            }
            if isLowercasedCharacter && isUppercasedCharacter && isDigitCharacter {
                return true
            }
        }
        return false
    }
}
