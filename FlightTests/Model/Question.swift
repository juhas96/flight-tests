import Foundation

struct Question: Codable {
    let id: String?
    let questionText: String
    let answers: [String]
    let correctAnswerPosition: Int
    let testName: String
    let categoryName: String
    let questionImage: String?
}
