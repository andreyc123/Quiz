//
//  LoginView.swift
//  Quiz
//

import SwiftUI

struct LoginView: View {
    enum Field: Hashable {
        case emailField
        case passwordField
    }
    
    @StateObject var viewModel = LoginViewModel(apiClient: FirebaseApiClient.shared)
    @FocusState private var focusedField: Field?
    @State private var isShowingSignupView = false
    @State private var toastData: ToastData?
    
    private var isLoginButtonEnabled: Bool {
        !viewModel.isProgressIndicator && !viewModel.email.isEmpty && !viewModel.password.isEmpty
    }

    private var emailErrorMessage: String? {
        if case LoginViewModel.State.validationError(let emailField) = viewModel.state {
            return emailField
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            LinearGradient
                .defaultAppBackground
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("Quiz")
                        .font(.custom("Avenir", size: 64.0))
                        .foregroundColor(.white.opacity(0.65))
                        .padding(.top, 30)
                    
                    VStack(spacing: 30) {
                        VStack(spacing: 20) {
                            InputTextFieldView(placeholder: "Email",
                                               errorMessage: emailErrorMessage,
                                               text: $viewModel.email)
                            .focused($focusedField, equals: .emailField)
                            .submitLabel(.next)
                            .textFieldEmailStyle()
                            .onSubmit { focusedField = .passwordField }
                            
                            InputPasswordFieldView(placeholder: "Password", text: $viewModel.password)
                                .submitLabel(.done)
                                .onSubmit(logIn)
                                .focused($focusedField, equals: .passwordField)
                        }
                        
                        VStack(spacing: 20) {
                            ButtonView(title: "Log In",
                                       isDisabled: !isLoginButtonEnabled,
                                       isProgressIndicator: viewModel.isProgressIndicator,
                                       action: logIn)
                            
                            ButtonView(title: "Sign Up") { isShowingSignupView = true }
                            
                            NavigationLink(destination: ForgotPasswordView(toastData: $toastData)) {
                                Text("Forgot password")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(Color.black.opacity(0.75))
                                    .underline()
                                    .padding()
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18))
                .errorAlert(isPresented: $viewModel.alert,
                            message: viewModel.state.errorMessage ?? "")
                .toastView(data: $toastData)
            }
        }
        .background {
            NavigationLink(destination: SignUpView(), isActive: $isShowingSignupView) { EmptyView() }
        }
    }
    
    private func logIn() {
        guard isLoginButtonEnabled else {
            return
        }
        
        viewModel.logIn()
        if emailErrorMessage != nil {
            let time: DispatchTime = .now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: time) {
                focusedField = .emailField
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
