//
//  TestsViewModel.swift
//  Quiz
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

final class TestsViewModel: ObservableObject {
    @Published var tests: [Test] = []
    @Published var state: GeneralViewState = .undefined
    @Published var alert = false
    
    private var refHandle: DatabaseHandle?
    
    func getTests() {
        state = .progressIndicator
        refHandle = Database.root
            .child(.testsKey)
            .ref.observe(.value) { [weak self] snapshot, _ in
                guard let strongSelf = self else {
                    return
                }
                
                guard let value = snapshot.value as? [String: JSON] else {
                    strongSelf.showErrorAlert(with: CustomError.unknown)
                    return
                }
                
                strongSelf.tests = value.compactMap { Test(id: $0.key, dict: $0.value) }
                    .sorted { $0.position < $1.position }
                strongSelf.state = .success
            }
    }
    
    func onDisappear() {
        if let refHandle = refHandle {
            Database.root.child(.testsKey).removeObserver(withHandle: refHandle)
        }
    }
    
    private func showErrorAlert(with error: Error) {
        state = .error(error)
        alert = true
    }
}
