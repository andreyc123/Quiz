//
//  ApiClient.swift
//  Quiz
//

import Combine

protocol ApiClient: AnyObject {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error>
    func createUser(email: String, password: String) -> AnyPublisher<String, Error>
    func resetPassword(email: String) -> AnyPublisher<Void, Error>
    func getUser(userID: String) -> AnyPublisher<User, Error>
    func updateUser(uid: String, user: User) -> AnyPublisher<Void, Error>
    func getTests() -> AnyPublisher<[Test], Error>
    func getTestQuestions(id: String) -> AnyPublisher<[(question: Question, answers: [Answer])], Error>
    func getCurrentUserID() -> String?
    func signOut() throws
}
