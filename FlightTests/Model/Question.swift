import Foundation

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerPosition: Int
    let testId: Int
    
    init(text: String, answers: [String], correctAnswerPosition: Int, testId: Int) {
        self.text = text
        self.answers = answers
        self.correctAnswerPosition = correctAnswerPosition
        self.testId = testId
    }
}
