//
//  FirebaseApiClient.swift
//  Quiz
//

import Combine
import FirebaseAuth
import FirebaseDatabase

private extension String {
    func toID() -> Int {
        let digits = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return Int(digits) ?? 0
    }
}

final class FirebaseApiClient: ApiClient {
    static let shared = FirebaseApiClient()
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(Void()))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let result = result {
                        let uid = result.user.uid
                        promise(.success(uid))
                    } else {
                        promise(.failure(CustomError.unknown))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(Void()))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getUser(userID: String) -> AnyPublisher<User, Error> {
        Deferred {
            Future { promise in
                Database.root
                    .child(.usersKey)
                    .child(userID)
                    .getData { error, snapshot in
                        if let error = error {
                            promise(.failure(error))
                        } else if let value = snapshot?.value as? JSON,
                                  let user = User(dict: value) {
                            promise(.success(user))
                        } else {
                            promise(.failure(CustomError.unknown))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateUser(uid: String, user: User) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let values = user.toJSON()
                Database
                    .root
                    .child(.usersKey)
                    .child(uid)
                    .updateChildValues(values) { error, ref in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(Void()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getTests() -> AnyPublisher<[Test], Error> {
        Deferred {
            Future { promise in
                Database.root
                    .child(.testsKey)
                    .getData { error, snapshot in
                        if let error = error {
                            promise(.failure(error))
                        } else if let value = snapshot?.value as? [String: JSON] {
                            let result = value.compactMap { Test(id: $0.key, dict: $0.value) }
                                .sorted { $0.position < $1.position }
                            promise(.success(result))
                        } else {
                            promise(.failure(CustomError.unknown))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getTestQuestions(id: String) -> AnyPublisher<[(question: Question, answers: [Answer])], Error> {
        Deferred {
            Future { promise in
                Database.root
                    .child(.testsQuestionsKey)
                    .child(id)
                    .getData { error, snapshot in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            guard let questionsDict = snapshot?.value as? JSON else {
                                promise(.failure(CustomError.unknown))
                                return
                            }
                            
                            let result: [(question: Question, answers: [Answer])] = questionsDict.compactMap {
                                guard let questionDict = $0.value as? JSON else {
                                    return nil
                                }
                                
                                guard let question = Question(id: $0.key.toID(), dict: questionDict) else {
                                    return nil
                                }
                                
                                guard let answersDict = questionDict[.answersKey] as? JSON else {
                                    return nil
                                }
                                
                                let answers: [Answer] = answersDict.compactMap {
                                    guard let answerDict = $0.value as? JSON else {
                                        return nil
                                    }
                                    return Answer(id: $0.key.toID(), dict: answerDict)
                                }.sorted { $0.id < $1.id }
                                return (question: question, answers: answers)
                            }.sorted { $0.question.id < $1.question.id }
                            promise(.success(result))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getCurrentUserID() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
