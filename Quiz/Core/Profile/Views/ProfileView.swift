//
//  ProfileView.swift
//  Quiz
//

import SwiftUI

struct ProfileView: View {
    enum Field: Hashable {
        case firstNameField
        case lastNameField
    }
    
    @StateObject var viewModel = ProfileViewModel(apiClient: FirebaseApiClient.shared)
    @FocusState private var focusedField: Field?
    
    private var isUpdateButtonEnabled: Bool {
        !viewModel.isUpdateProgressIndicator &&
        !viewModel.user.firstName.isEmpty &&
        !viewModel.user.lastName.isEmpty
    }
    
    private var editProfile: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    InputTextFieldView(placeholder: "First name", text: $viewModel.user.firstName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lastNameField }
                        .focused($focusedField, equals: .firstNameField)
                    
                    InputTextFieldView(placeholder: "Last name", text: $viewModel.user.lastName)
                        .submitLabel(.done)
                        .onSubmit(update)
                        .focused($focusedField, equals: .lastNameField)
                }
                
                VStack(spacing: 20) {
                    ButtonView(title: "Update",
                               isDisabled: !isUpdateButtonEnabled,
                               isProgressIndicator: false,
                               action: update)
                    
                    ButtonView(title: "Logout",
                               isDisabled: false,
                               isProgressIndicator: false,
                               action: viewModel.signOut)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18))
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.defaultAppBackground
                .ignoresSafeArea()
            
            VStack {
                CustomTitleView(title: "Profile")
                    .padding(.top, 15)
                
                switch viewModel.state {
                case .undefined, .progressIndicator:
                    Spacer()
                default:
                    editProfile
                        .errorAlert(isPresented: $viewModel.alert,
                                    message: viewModel.state.errorMessage ?? "")
                }
            }
            
            if case .progressIndicator = viewModel.state {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.getProfile()
        }
        .onDisappear {
            viewModel.onViewDisappear()
        }
        .toastView(data: $viewModel.toastData)
    }
    
    private func update() {        
        guard isUpdateButtonEnabled else {
            return
        }

        viewModel.update()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
