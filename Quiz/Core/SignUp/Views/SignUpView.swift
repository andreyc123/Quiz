//
//  SignUpView.swift
//  Quiz
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case emailField
        case passwordField
        case repeatPasswordField
        case firstNameField
        case lastNameField
    }
    
    @StateObject var viewModel = SignUpViewModel(apiClient: FirebaseApiClient.shared)
    @FocusState private var focusedField: Field?
    @Environment(\.presentationMode) var presentationMode
    
    private var headerView: some View {
        HStack {
            CustomBackButton {
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .background(
            CustomTitleView(title: "Register")
        )
    }
    
    private var emailErrorMessage: String? {
        if case SignUpViewModel.State.validationError(let emailField, _, _) = viewModel.state {
            return emailField
        }
        return nil
    }
    
    private var passwordErrorMessage: String? {
        if case SignUpViewModel.State.validationError(_, let passwordField, _) = viewModel.state {
            return passwordField
        }
        return nil
    }
    
    private var repeatPasswordErrorMessage: String? {
        if case SignUpViewModel.State.validationError(_, _, let repeatPasswordField) = viewModel.state {
            return repeatPasswordField
        }
        return nil
    }
    
    private var isRegisterButtonEnabled: Bool {
        !viewModel.isProgressIndicator &&
        !viewModel.email.isEmpty &&
        !viewModel.password.isEmpty &&
        !viewModel.repeatPassword.isEmpty &&
        !viewModel.firstName.isEmpty &&
        !viewModel.lastName.isEmpty
    }
    
    var body: some View {
        ZStack {
            LinearGradient
                .defaultAppBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        VStack(spacing: 20) {
                            InputTextFieldView(placeholder: "Email",
                                               errorMessage: emailErrorMessage,
                                               text: $viewModel.email)
                            .textFieldEmailStyle()
                            .focused($focusedField, equals: .emailField)
                            .onSubmit { focusedField = .passwordField }
                            .padding(.top, 20)
                                                    
                            InputPasswordFieldView(placeholder: "Password",
                                                   errorMessage: passwordErrorMessage,
                                                   text: $viewModel.password)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .passwordField)
                            .onSubmit { focusedField = .repeatPasswordField }
                            
                            InputPasswordFieldView(placeholder: "Repeat password",
                                                   errorMessage: repeatPasswordErrorMessage,
                                                   text: $viewModel.repeatPassword)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .repeatPasswordField)
                            .onSubmit { focusedField = .firstNameField }
                            
                            InputTextFieldView(placeholder: "First name", text: $viewModel.firstName)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .lastNameField }
                                .focused($focusedField, equals: .firstNameField)
                            
                            InputTextFieldView(placeholder: "Last name", text: $viewModel.lastName)
                                .submitLabel(.done)
                                .onSubmit(signUp)
                                .focused($focusedField, equals: .lastNameField)
                        }
                        
                        ButtonView(title: "Register",
                                   isDisabled: !isRegisterButtonEnabled,
                                   isProgressIndicator: viewModel.isProgressIndicator,
                                   action: signUp)
                    }
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18))
                }
            }
        }
        .errorAlert(isPresented: $viewModel.alert, message: viewModel.state.errorMessage ?? "")
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func signUp() {
        guard isRegisterButtonEnabled else {
            return
        }
        
        viewModel.signUp()
        
        func focus(_ field: Field) {
            let time: DispatchTime = .now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: time) {
                focusedField = field
            }
        }
        
        if emailErrorMessage != nil {
            focus(.emailField)
        } else if passwordErrorMessage != nil {
            focus(.passwordField)
        } else if repeatPasswordErrorMessage != nil {
            focus(.repeatPasswordField)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
