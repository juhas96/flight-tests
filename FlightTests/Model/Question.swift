import Foundation

struct Question: Codable {
    let id, questionText: String
    let answers: [String]
    let correctAnswerPosition: Int
    let testName: TestName
    let categoryName: CategoryName
    let questionImage: String?
}

enum CategoryName: String, Codable {
    case aerodynamika = "Aerodynamika"
}

enum TestName: String, Codable {
    case aerodynamikaX63 = "Aerodynamika X63"
}
