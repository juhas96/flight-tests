import Foundation

struct Test {
    var questionNumber = 0
    var questionId = "-1"
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
    
    func getQuestionIdByQuestionPosition(position: Int) -> String {
        if test.count > 0 {
            return test[position].id!
        } else {
            return "-1"
        }
    }
    
    mutating func initFirstQuestionId() {
        if test.count > 0 {
            self.questionId = test[0].id!
        }
    }
    
    mutating func nextQuestion() {
        if (test.count > 0) {
            if questionNumber + 1 < test.count {
                questionNumber += 1
                self.questionId = self.test[questionNumber].id!
            } else {
                questionNumber = test.count
                self.questionId = self.test[questionNumber - 1].id!
            }
        }
    }
    
    mutating func previousQuestion() {
        if (test.count > 0) {
            self.questionId = self.test[questionNumber].id!
            if questionNumber != 0 {
                questionNumber -= 1
                self.questionId = self.test[questionNumber].id!
            }
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
    
    mutating func checkAnswerOnPosition(userAnswer: Int, position: Int) -> Void {
        if test.count > 0 {
            if userAnswer == test[position].correctAnswerPosition {
                correctAnswers += 1
            } else {
                wrongAnswers += 1
            }
        }
    }
    
    mutating func checkAnswerWithId(userAnswer: Int, id: String) -> [String:Bool] {
        if test.count > 0 {
            if let index = test.firstIndex(where: {$0.id == id}) {
                if userAnswer == test[index].correctAnswerPosition {
                    return [test[index].categoryName: true]
                } else {
                    return [test[index].categoryName: false]
                }
            }
        }
        return [:]
    }
}
