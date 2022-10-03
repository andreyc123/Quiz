//
//  User.swift
//  Quiz
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    
    var fullName: String {
        [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    static var `default`: User {
        User(firstName: "", lastName: "")
    }
    
    func toJSON() -> JSON {
        return [.firstNameKey: firstName,
                .lastNameKey: lastName]
    }
}

extension User {
    init?(dict: JSON) {
        guard let firstName = dict[.firstNameKey] as? String, let lastName = dict[.lastNameKey] as? String else {
            return nil
        }
    
        self.firstName = firstName
        self.lastName = lastName
    }
}
