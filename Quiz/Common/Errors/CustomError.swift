//
//  CustomError.swift
//  Quiz
//

import Foundation

enum CustomError: Error {
    case message(String)
    
    static var unknown: CustomError {
        return .message(.unknownErrorMessage)
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .message(let description):
            return description
        }
    }
}
