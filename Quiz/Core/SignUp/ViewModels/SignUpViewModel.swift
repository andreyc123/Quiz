//
//  SignUpViewModel.swift
//  Quiz
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    enum State {
        case normal
        case validationError(emailField: String?,
                             passwordField: String?,
                             repeatPasswordField: String?)
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
    @Published var repeatPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var state: State = .normal
    @Published var isProgressIndicator = false
    @Published var alert = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func signUp() {
        guard email.isValidEmail else {
            withAnimation {
                state = .validationError(emailField: .incorrectEmailErrorMessage,
                                         passwordField: nil,
                                         repeatPasswordField: nil)
            }
            return
        }
        
        guard password.isStrongPassword else {
            withAnimation {
                state = .validationError(emailField: nil,
                                         passwordField: .unreliablePasswordErrorMessage,
                                         repeatPasswordField: nil)
            }
            return
        }
        
        guard password == repeatPassword else {
            withAnimation {
                state = .validationError(emailField: nil,
                                         passwordField: nil,
                                         repeatPasswordField: .passwordConfirmationErrorMessage)
            }
            return
        }
        
        state = .normal
        isProgressIndicator = true
        
        let user = User(firstName: firstName, lastName: lastName)
        let apiClient = self.apiClient
        apiClient.createUser(email: email, password: password)
            .flatMap { uid in
                apiClient.updateUser(uid: uid, user: user)
            }
            .sink { [weak self] result in
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
