import Foundation

struct Test {
    var questionNumber = 0
    
    let test: [Question] = [
        Question(text: "Základnými fyzikálnymi jednotkami podľa SI sú", answers: ["meter, kilogram, sekunda, ampér, kelvin, mol, kandela", "meter, kilogram, sekunda, kilopond, bar, kalória, gauss", "meter, decimeter, hodina, joule, watt, volt, ohm"], correctAnswerPosition: 0),
        Question(text: "Atmosféra alebo vzdušný obal zeme sa delí na štyri vrstvy. Najnižšia z nich - troposféra dosahuje do výšky asi", answers: ["8 km", "11,5 km", "13km"], correctAnswerPosition: 1),
        Question(text: "Ideálnym plynom rozumieme plyn", answers: ["nestlačiteľný, s vnútorným trením", "stlačiteľný, s vnútorným trením", "stlačiteľný, bez vnútorného trenia"], correctAnswerPosition: 1)
    ]
    
    func getQuestionText() -> String {
        if test.count > 0 {
            return test[questionNumber].text
        } else {
            return "No questions in test"
        }
    
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(test.count)
    }
    
    func getAnswerOnPosition(position: Int) -> String {
        if test.count > 0 {
            return test[questionNumber].answers[position]
        } else {
            return "No questions in test"
        }
    }
    
    mutating func nextQuestion() {
        if questionNumber + 1 < test.count {
            questionNumber += 1
        } else {
            questionNumber = 0
        }
    }
    
    mutating func checkAnswer(userAnswer: Int) -> Bool {
        if test.count > 0 {
            if userAnswer == test[questionNumber].correctAnswerPosition {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
