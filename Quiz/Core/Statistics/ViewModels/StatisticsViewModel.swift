//
//  StatisticsViewModel.swift
//  Quiz
//

import SwiftUI
import Combine

final class StatisticsViewModel: ObservableObject {
    let totalNumberOfQuestions: Int
    let numberOfCorrectAnswers: Int
    let apiClient: ApiClient
    
    @Published var user: User = .default
    @Published var state: GeneralViewState = .undefined
    @Published var alert = false
    
    var numberOfIncorrectAnswers: Int {
        totalNumberOfQuestions - numberOfCorrectAnswers
    }
    
    private var subscription: AnyCancellable?
    
    init(totalNumberOfQuestions: Int,
         numberOfCorrectAnswers: Int,
         apiClient: ApiClient) {
        self.totalNumberOfQuestions = totalNumberOfQuestions
        self.numberOfCorrectAnswers = numberOfCorrectAnswers
        self.apiClient = apiClient
    }
    
    func getProfile() {
        guard let userID = apiClient.getCurrentUserID() else {
            state = .error(CustomError.unknown)
            return
        }
        
        state = .progressIndicator
        subscription = apiClient.getUser(userID: userID)
            .sink { [weak self] completion in
                self?.subscription?.cancel()
                self?.subscription = nil
                
                switch completion {
                case .finished:
                    self?.state = .success
                case .failure(let error):
                    self?.state = .error(error)
                    self?.alert = true
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
    }
}
