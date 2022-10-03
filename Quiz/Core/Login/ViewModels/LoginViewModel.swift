//
//  LoginViewModel.swift
//  Quiz
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    enum State {
        case normal
        case validationError(emailField: String?)
        case error(Error)
        
        var errorMessage: String? {
            if case .error(let error) = self {
                return error.localizedDescription
            }
            return nil
        }
    }
    
    let apiClient: ApiClient
    
    @AppStorage(.isSignedInKey) var isSignedIn = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var state: State = .normal
    @Published var isProgressIndicator = false
    @Published var alert = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func logIn() {
        guard email.isValidEmail else {
            withAnimation {
                state = .validationError(emailField: .incorrectEmailErrorMessage)
            }
            return
        }
        
        state = .normal
        isProgressIndicator = true
        
        apiClient.signIn(email: email, password: password).sink { [weak self] result in
            self?.isProgressIndicator = false
            switch result {
            case .failure(let error):
                self?.state = .error(error)
                self?.alert = true
            default:
                break
            }
        } receiveValue: { [weak self] _ in
            self?.isSignedIn = true
        }
        .store(in: &subscriptions)
    }
}
