//
//  ForgotPasswordViewModel.swift
//  Quiz
//

import SwiftUI
import Combine

final class ForgotPasswordViewModel: ObservableObject {
    let apiClient: ApiClient
    
    @Published var email = ""
    @Published var state: LoginViewModel.State = .normal
    @Published var isProgressIndicator = false
    @Published var alert = false
    
    @Binding var toastData: ToastData?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(toastData: Binding<ToastData?>, apiClient: ApiClient) {
        _toastData = toastData
        self.apiClient = apiClient
    }
    
    func reset(with successBlock: @escaping () -> Void) {
        guard email.isValidEmail else {
            withAnimation {
                state = .validationError(emailField: .incorrectEmailErrorMessage)
            }
            return
        }
        
        state = .normal
        isProgressIndicator = true
        
        apiClient.resetPassword(email: email)
            .sink { [weak self] completion in
                self?.isProgressIndicator = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.state = .error(error)
                    self?.alert = true
                }
            } receiveValue: { [weak self] _ in
                self?.toastData = ToastData(type: .success, message: "Your password has been reset", duration: 2)
                successBlock()
            }
            .store(in: &subscriptions)
    }
}
