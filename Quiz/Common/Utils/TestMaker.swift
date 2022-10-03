//
//  TestMaker.swift
//  Quiz
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct Question_ {
    let text: String
    let answers: [String]
    
    var toJSON: JSON {
        var answersJSON = JSON()
        for (index, value) in answers.enumerated() {
            var isCorrect = false
            var answer = value
            if answer.count > 2 && answer.hasPrefix("*") {
                answer = String(answer.dropFirst(2))
                isCorrect = true
            }
            let answerData: JSON = [.textKey: answer, .isCorrectKey: isCorrect]
            let key = "key_\(index + 1)"
            answersJSON[key] = answerData
        }
        return [.textKey: text, .answersKey: answersJSON]
    }
    
    static func q(text: String, _ answers: String ...) -> Question_ {
        Question_(text: text, answers: answers)
    }
}

struct TestContainer_ {
    let questions: [Question_]
    
    var toJSON: JSON {
        var result = JSON()
        for (index, value) in questions.enumerated() {
            let key = "key_\(index + 1)"
            result[key] = value.toJSON
        }
        return result
    }
}

final class TestMaker {
    static func makeQuestion(testId: String, testContainer: TestContainer_) {
        let values = testContainer.toJSON
        Database.root
            .child(.testsQuestionsKey)
            .child(testId)
            .updateChildValues(values) { error, ref in
                if let error = error {
                    print(error)
                } else {
                    print("*** success ***")
                }
            }
    }
}

extension TestMaker {
    static func test1() {
        let t = TestContainer_(questions: [
            .q(text: "A noun:",
               "describes a verb",
               "is an action word or state of being",
               "* is a person, place, thing",
               "describes an action"),
            .q(text: "An ____ describes a noun.",
               "* adjective",
               "adverb"),
            .q(text: "Ronnie yells loudly. 'Ronnie' is ____.",
               "* a noun",
               "a verb",
               "an adverb",
               "an adjective"),
            .q(text: "Ronnie yells loudly. 'Yells' is ____.",
               "a noun",
               "* a verb",
               "an adverb",
               "an adjective"),
            .q(text: "Ronnie yells loudly. 'Loudly' is ____.",
               "a noun",
               "a verb",
               "* an adverb",
               "an adjective"),
            .q(text: "The rat has a long tail. What word is the verb?",
               "rat",
               "* has",
               "a",
               "long",
               "tail"),
            .q(text: "The rat has big teeth. What word is the adjective?",
               "rat",
               "has",
               "* big",
               "teeth"),
            .q(text: "The rat has big teeth. What word is the noun?",
               "rat",
               "has",
               "big",
               "teeth",
               "rat & big",
               "big & teeth",
               "* rat & teeth",
               "the & rat"),
            .q(text: "An adverb ____ a verb.",
               "is",
               "* describes",
               "reverses"),
            .q(text: "Nouns that are names are called ____ nouns.",
               "name",
               "adjective",
               "illustrious",
               "* proper")
        ])
        TestMaker.makeQuestion(testId: "1ed0c6f3-81cc-46fb-a492-b4014ff45513", testContainer: t)
    }
    
    static func test2() {
        let t = TestContainer_(questions: [
            .q(text: "____ I wear a suit to the wedding?",
                "Must",
                "* Should",
                "Mustn't",
                "Have to"
            ),
            .q(text: "You ____ finish your homework before you play games.",
                "* have to",
                "should",
                "mustn't",
                "haven't got to"
            ),
            .q(text: "'Should' often follows:",
               "'advice'",
               "'could'",
               "'must'",
               "* ‘think'"
            ),
            .q(text: "How can you express thanks?",
               "You must have.",
               "You should have.",
               "You mustn't have.",
               "* “You shouldn't have."
            ),
            .q(text: "Which letter is almost silent in \"mustn't\"?",
               "m",
               "u",
               "s",
               "* first t",
               "n",
               "second t"
            ),
            .q(text: "Express polite enthusiasm: \"We ____ catch up soon.\"",
               "should",
               "should have",
               "* must",
               "mustn't"
            )
        ])
        TestMaker.makeQuestion(testId: "11dad3a7-b42e-4e00-9bd2-e75a63a945b0", testContainer: t)
    }
}
