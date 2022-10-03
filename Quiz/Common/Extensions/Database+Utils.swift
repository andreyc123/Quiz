//
//  Database+Utils.swift
//  Quiz
//

import FirebaseDatabase

typealias JSON = [String: Any]

extension Database {
    static var root: DatabaseReference {
        return database().reference()
    }
}
