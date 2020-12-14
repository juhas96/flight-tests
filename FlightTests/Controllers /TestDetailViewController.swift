//
//  TestDetailViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 04/12/2020.
//

import UIKit
import FontAwesome_swift

class TestDetailViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var previousQuestionButton: CircleButton!
    @IBOutlet weak var nextQuestionButton: CircleButton!
    
    var testName: String = ""
    var test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(rgb: 0x2886BB).cgColor, UIColor(rgb: 0x25CCF0).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect.zero
            return gradientLayer
        }()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.view.bounds
        var data = DataService.data.getData()
        test.test = data.filter({ (Question) -> Bool in
            return Question.testName == self.testName
        })
        self.setupUI()
        self.updateUI()
    }
    
    @IBAction func showAnswerButtonTapped(_ sender: AnswerButton) {
        self.answerTextLabel.text = test.getAnswerOnPosition(position: 0)
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
    
    func setupUI() {
        self.questionTextLabel.layer.cornerRadius = 20.0
        self.questionTextLabel.layer.masksToBounds = true
        self.questionTextLabel.sizeToFit()
        
        self.answerTextLabel.layer.cornerRadius = 20.0
        self.answerTextLabel.layer.masksToBounds = true
        self.answerTextLabel.sizeToFit()
        
        self.nextQuestionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.nextQuestionButton.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        
        self.previousQuestionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.previousQuestionButton.setTitle(String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
    }
}
