//
//  ForgotPasswordView.swift
//  Quiz
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel: ForgotPasswordViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    private var isLoginButtonEnabled: Bool {
        !viewModel.isProgressIndicator && !viewModel.email.isEmpty
    }
    
    private var emailErrorMessage: String? {
        if case LoginViewModel.State.validationError(let emailField) = viewModel.state {
            return emailField
        }
        return nil
    }
    
    private var headerView: some View {
        HStack {
            CustomBackButton {
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(viewModel.isProgressIndicator)
            
            Spacer()
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.defaultAppBackground
                .ignoresSafeArea()
        
            VStack {
                headerView
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("Forgot Password")
                            .font(.custom("Avenir", size: 32.0))
                            .foregroundColor(.white)
                        
                        InputTextFieldView(placeholder: "Email",
                                           errorMessage: emailErrorMessage,
                                           text: $viewModel.email)
                        .textFieldEmailStyle()
                        .padding(.top, 10)
                        
                        ButtonView(title: "Reset",
                                   isDisabled: !isLoginButtonEnabled,
                                   isProgressIndicator: viewModel.isProgressIndicator,
                                   action: reset)
                        .submitLabel(.done)
                        .onSubmit(reset)
                        .padding(.vertical, 20)
                        .errorAlert(isPresented: $viewModel.alert,
                                    message: viewModel.state.errorMessage ?? "")
                    }
                    .padding(.horizontal, 18)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    init(toastData: Binding<ToastData?>) {
        _viewModel = StateObject(wrappedValue: ForgotPasswordViewModel(toastData: toastData, apiClient: FirebaseApiClient.shared))
    }
    
    // MARK: - Private
    
    private func reset() {
        viewModel.reset {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(toastData: .constant(nil))
    }
}
