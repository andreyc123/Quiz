//
//  GeneralViewState.swift
//  Quiz
//

import Foundation

enum GeneralViewState {
    case undefined
    case progressIndicator
    case success
    case error(Error)
    
    var errorMessage: String? {
        if case .error(let error) = self {
            return error.localizedDescription
        }
        return nil
    }
}
