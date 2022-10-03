//
//  ProfileViewModel.swift
//  Quiz
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseDatabase

final class ProfileViewModel: ObservableObject {
    let apiClient: ApiClient
    
    @AppStorage(.isSignedInKey) var isSignedIn = false
    
    @Published var user: User = .default
    @Published var state: GeneralViewState = .undefined
    @Published var toastData: ToastData?
    @Published var isUpdateProgressIndicator = false
    @Published var isProgressIndicator = false
    @Published var alert = false
    
    private var ref = Database.root
    private var refHandle: DatabaseHandle?
    private var subscriptions = Set<AnyCancellable>()
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getProfile() {
        guard let userID = apiClient.getCurrentUserID() else {
            showErrorAlert(with: CustomError.unknown)
            return
        }
        
        let profileRef = Database.root
            .child(.usersKey)
            .child(userID)
        fetchProfile(from: profileRef)
    }
    
    func onViewDisappear() {
        if let refHandle = refHandle, let userID = apiClient.getCurrentUserID() {
            ref.child(.usersKey).child(userID).removeObserver(withHandle: refHandle)
        }
    }
    
    func update() {
        guard let userID = apiClient.getCurrentUserID() else {
            showErrorAlert(with: CustomError.unknown)
            return
        }
        
        isUpdateProgressIndicator = true
        apiClient.updateUser(uid: userID, user: user)
            .sink { [weak self] result in
                self?.isUpdateProgressIndicator = false
                switch result {
                case .failure(let error):
                    self?.showErrorAlert(with: error)
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.toastData = .info("Your profile has been successfully updated")
            }
            .store(in: &subscriptions)
    }
    
    func signOut() {
        do {
            try apiClient.signOut()
            withAnimation {
                isSignedIn = false
            }
        } catch {
            showErrorAlert(with: error)
        }
    }
    
    // MARK: - Private
    
    private func fetchProfile(from ref: DatabaseReference) {
        state = .progressIndicator
        refHandle = ref.observe(.value) { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let value = snapshot.value as? JSON,
                  let user = User(dict: value) else {
                strongSelf.showErrorAlert(with: CustomError.unknown)
                return
            }
            
            strongSelf.state = .success
            strongSelf.user = user
        }
    }
    
    private func showErrorAlert(with error: Error) {
        state = .error(error)
        alert = true
    }
}
