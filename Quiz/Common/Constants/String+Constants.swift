//
//  String+Constants.swift
//  Quiz
//

import Foundation

// MARK: - Keys

extension String {
    static let isSignedInKey        = "isSignedIn"
    static let usersKey             = "users"
    static let testsKey             = "tests"
    static let testsQuestionsKey    = "tests-questions"
    static let idKey                = "id"
    static let positionKey          = "position"
    static let answersKey           = "answers"
    static let uidKey               = "uid"
    static let firstNameKey         = "firstName"
    static let lastNameKey          = "lastName"
    static let textKey              = "text"
    static let questionCountKey     = "question-count"
    static let isCorrectKey         = "isCorrect"
}

// MARK: - Messages

extension String {
    static let incorrectEmailErrorMessage = "Please check if email address is correct"
    static let unreliablePasswordErrorMessage = "The password should have from \(Constants.minAllowedPasswordSymbols) characters, including lower and upper case letters and digits"
    static let passwordConfirmationErrorMessage = "Entered password doesn't match"
    static let unknownErrorMessage = "Something went wrong"
}
