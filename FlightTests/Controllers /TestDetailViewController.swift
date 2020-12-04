//
//  TestDetailViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 04/12/2020.
//

import UIKit

class TestDetailViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    
    var testName: String = ""
    var test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = DataService.data.getData()
        test.test = data.filter({ (Question) -> Bool in
            return Question.testName.rawValue == self.testName
        })
        self.updateUI()
        print(test.test)
    }
    
    @IBAction func showAnswerButtonTapped(_ sender: AnswerButton) {
        self.answerTextLabel.text = test.getAnswerOnPosition(position: test.questionNumber)
    }
    @IBAction func previousButtonTapped(_ sender: AnswerButton) {
        self.test.previousQuestion()
        updateUI()
    }
    
    @IBAction func nextButtonTapped(_ sender: AnswerButton) {
        self.test.nextQuestion()
        updateUI()
    }
    
    @objc func updateUI() {
        questionTextLabel?.text = test.getQuestionText()
        self.answerTextLabel.text = "Pre zobrazenie odpovede kliknite na tlacidlo"
    }
}
