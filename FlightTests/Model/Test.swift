import Foundation

struct Test {
    var questionNumber = 0
    var correctAnswers = 0
    var wrongAnswers = 0
    
    var test: [Question] = []
    
    func getQuestionText() -> String {
        if test.count > 0 && questionNumber != test.count {
            return test[questionNumber].questionText
        } else {
            return "No questions in test"
        }
    
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(test.count)
    }
    
    func getAnswerOnPosition(position: Int) -> String {
        if test.count > 0 && questionNumber != test.count {
            return test[questionNumber].answers[position]
        } else {
            return "No questions in test"
        }
    }
    
    mutating func nextQuestion() {
        if questionNumber + 1 < test.count {
            questionNumber += 1
        } else {
        
            questionNumber = test.count
        }
    }
    
    mutating func previousQuestion() {
        print("Question number: \(questionNumber)")
        print(questionNumber - 1 >= 1)
        if questionNumber != 0 {
            questionNumber -= 1
        }
    }
    
    mutating func checkAnswer(userAnswer: Int) -> Bool {
        if test.count > 0 {
            if userAnswer == test[questionNumber].correctAnswerPosition {
                correctAnswers += 1
                return true
            } else {
                wrongAnswers += 1
                return false
            }
        } else {
            return false
        }
    }
}
