import Foundation

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerPosition: Int
    
    init(text: String, answers: [String], correctAnswerPosition: Int) {
        self.text = text
        self.answers = answers
        self.correctAnswerPosition = correctAnswerPosition
    }
}
