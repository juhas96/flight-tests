//
//  OldTestViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 14/12/2020.
//

import UIKit
import FontAwesome_swift

class OldTestViewController: UIViewController {
    
    @IBOutlet weak var questionTextLabel: PaddingLabel!
    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var nextButton: CircleButton!
    @IBOutlet weak var firstButton: AnswerButton!
    @IBOutlet weak var secondButton: AnswerButton!
    @IBOutlet weak var thirdButton: AnswerButton!
    
    var oldTest = UserTest(id: 0, questionIds: [], userAnswers: [])
    var allQuestions = [Question]()
    var test = Test()
    var currentlySelectedButton: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTest()
        updateUI()
        updateButtonsColor()
        print(oldTest)
    }
    
    func initTest() {
        self.allQuestions = DataService.data.getData()
        self.allQuestions = self.allQuestions.filter({ (q) -> Bool in
            oldTest.questionIds.contains(q.id!)
        })
        test.test = self.allQuestions
        test.initFirstQuestionId()
        self.updateUI()
    }
    
    func setupQuestionLabel() {
        self.questionTextLabel.layer.cornerRadius = 20.0
        self.questionTextLabel.layer.masksToBounds = true
        self.questionTextLabel.textColor = .black
        self.questionTextLabel.sizeToFit()
    }
    
    func initUI() {
        let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(rgb: 0x2886BB).cgColor, UIColor(rgb: 0x25CCF0).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect.zero
            return gradientLayer
        }()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.view.bounds
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        self.nextButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.nextButton.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        
        self.backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.backButton.setTitle(String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
        
        self.title = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.firstButton.isEnabled = false
        self.secondButton.isEnabled = false
        self.thirdButton.isEnabled = false
        
        self.setupQuestionLabel()
        
        self.currentlySelectedButton = Int(self.oldTest.userAnswers[Int(self.test.questionNumber)])!
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.test.previousQuestion()
        self.currentlySelectedButton = Int(self.oldTest.userAnswers[Int(self.test.questionNumber)])!
        updateButtonsColor()
        self.updateUI()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.test.nextQuestion()
        self.currentlySelectedButton = Int(self.oldTest.userAnswers[Int(self.test.questionNumber)])!
        updateButtonsColor()
        self.updateUI()
    }
    
    func updateButtonsColor() {
        
        firstButton.backgroundColor = UIColor.white
        firstButton.setTitleColor(.black, for: .normal)
        secondButton.backgroundColor = UIColor.white
        secondButton.setTitleColor(.black, for: .normal)
        thirdButton.backgroundColor = UIColor.white
        thirdButton.setTitleColor(.black, for: .normal)
        
        switch currentlySelectedButton {
        case 0:
            firstButton.backgroundColor = UIColor(rgb: 0xec0101)
            firstButton.setTitleColor(.white, for: .normal)
//            secondButton.backgroundColor = UIColor.white
//            secondButton.setTitleColor(.black, for: .normal)
//            thirdButton.backgroundColor = UIColor.white
//            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 1:
//            firstButton.backgroundColor = UIColor.white
//            firstButton.setTitleColor(.black, for: .normal)
            secondButton.backgroundColor = UIColor(rgb: 0xec0101)
            secondButton.setTitleColor(.white, for: .normal)
//            thirdButton.backgroundColor = UIColor.white
//            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 2:
//            firstButton.backgroundColor = UIColor.white
//            firstButton.setTitleColor(.black, for: .normal)
//            secondButton.backgroundColor = UIColor.white
//            secondButton.setTitleColor(.black, for: .normal)
            thirdButton.backgroundColor = UIColor(rgb: 0xec0101)
            thirdButton.setTitleColor(.white, for: .normal)
            break
        default:
            firstButton.backgroundColor = UIColor.white
            secondButton.backgroundColor = UIColor.white
            thirdButton.backgroundColor = UIColor.white
            firstButton.setTitleColor(.black, for: .normal)
            secondButton.setTitleColor(.black, for: .normal)
            thirdButton.setTitleColor(.black, for: .normal)
            break
        }
        
        switch self.test.test[self.test.questionNumber].correctAnswerPosition {
        case 0:
            firstButton.backgroundColor = UIColor(rgb: 0x5fbb97)
            firstButton.setTitleColor(.white, for: .normal)
//            secondButton.backgroundColor = UIColor.white
//            secondButton.setTitleColor(.black, for: .normal)
//            thirdButton.backgroundColor = UIColor.white
//            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 1:
//            firstButton.backgroundColor = UIColor.white
//            firstButton.setTitleColor(.black, for: .normal)
            secondButton.backgroundColor = UIColor(rgb: 0x5fbb97)
            secondButton.setTitleColor(.white, for: .normal)
//            thirdButton.backgroundColor = UIColor.white
//            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 2:
//            firstButton.backgroundColor = UIColor.white
//            firstButton.setTitleColor(.black, for: .normal)
//            secondButton.backgroundColor = UIColor.white
//            secondButton.setTitleColor(.black, for: .normal)
            thirdButton.backgroundColor = UIColor(rgb: 0x5fbb97)
            thirdButton.setTitleColor(.white, for: .normal)
            break
        default:
            break
        }
    }
    
    func updateUI() {
        if test.questionNumber == 0 {
            self.backButton.isEnabled = false
        } else {
            self.backButton.isEnabled = true
        }
        
        if test.questionNumber + 1 == test.test.count {
            self.nextButton.isEnabled = false
        } else {
            self.nextButton.isEnabled = true
        }
        
        self.title = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        questionTextLabel.attributedText = test.getQuestionText().htmlToAttributedString
        questionTextLabel.textAlignment = .center
        questionTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.currentlySelectedButton = Int(oldTest.userAnswers[test.questionNumber])!
        firstButton?.setAttributedTitle(test.getAnswerOnPosition(position: 0).htmlToAttributedString, for: .normal)
        secondButton?.setAttributedTitle(test.getAnswerOnPosition(position: 1).htmlToAttributedString, for: .normal)
        thirdButton?.setAttributedTitle(test.getAnswerOnPosition(position: 2).htmlToAttributedString, for: .normal)
    
    }

}
