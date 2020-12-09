import UIKit
import FontAwesome_swift
import SQLite


class NormalTestDetailViewController: UIViewController {
    
    var questions: [Question] = []
    var test = Test()
    var selectedAnswers: [Int: Int] = [:]
    var currentlySelectedButton: Int = -1
    var dbHelper = DbHelper()

    
    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var nextButton: CircleButton!
    @IBOutlet weak var firstButton: AnswerButton!
    @IBOutlet weak var secondButton: AnswerButton!
    @IBOutlet weak var thirdButton: AnswerButton!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var evaluateButton: AnswerButton!
    
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
        self.evaluateButton.isHidden = true
        self.evaluateButton.backgroundColor = UIColor.green
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.nextButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.nextButton.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        
        self.backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.backButton.setTitle(String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
        
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(10))
        self.updateUI()
    }
    
    func initTest(number: Int) -> [Question] {
        return Array(questions.choose(number))
    }
    @IBAction func evaluateButtonTapped(_ sender: UIButton) {
        for (questionPosition, answer) in selectedAnswers {
            self.test.checkAnswerOnPosition(userAnswer: answer, position: questionPosition)
        }
        
        do {
            self.dbHelper.update(correct: self.test.correctAnswers, wrong: self.test.wrongAnswers)
        } catch {
            print(error)
        }
        
        self.performSegue(withIdentifier: "ShowEvaluateScreenFromNormalTest", sender: self)
    }
    
    @IBAction func onFirstButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 0
        updateButtonsColor()
    }
    
    @IBAction func onSecondButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 1
        updateButtonsColor()
    }
    
    @IBAction func onThirdButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 2
        updateButtonsColor()
    }
    
    @IBAction func onNextQuestionButtonTapped(_ sender: UIButton) {
        self.selectedAnswers.updateValue(self.currentlySelectedButton, forKey: self.test.questionNumber)
        self.test.nextQuestion()
        self.currentlySelectedButton = -1
        updateButtonsColor()
        self.updateUI()
    }
    
    @IBAction func onPreviousButtonTapped(_ sender: UIButton) {
        self.test.previousQuestion()
        self.currentlySelectedButton = -1
        updateButtonsColor()
        self.updateUI()
    }
    
    func updateUI() {
        if test.questionNumber + 1 == test.test.count {
            self.evaluateButton.isHidden = false
        } else {
            self.evaluateButton.isHidden = true
        }
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
        
        self.questionNumberLabel.text = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        questionTextLabel.text = test.getQuestionText()
        
        if let value = selectedAnswers[test.questionNumber] {
            self.currentlySelectedButton = value
        }
        firstButton?.setTitle(test.getAnswerOnPosition(position: 0), for: UIControl.State.normal)
        secondButton?.setTitle(test.getAnswerOnPosition(position: 1), for: UIControl.State.normal)
        thirdButton?.setTitle(test.getAnswerOnPosition(position: 2), for: UIControl.State.normal)
        updateButtonsColor()
        
    }
    
    func updateButtonsColor() {
        switch currentlySelectedButton {
        case 0:
            firstButton.backgroundColor = UIColor(rgb: 0x25A4DA)
            firstButton.setTitleColor(.white, for: .normal)
            secondButton.backgroundColor = UIColor.white
            secondButton.setTitleColor(.black, for: .normal)
            thirdButton.backgroundColor = UIColor.white
            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 1:
            firstButton.backgroundColor = UIColor.white
            firstButton.setTitleColor(.black, for: .normal)
            secondButton.backgroundColor = UIColor(rgb: 0x25A4DA)
            secondButton.setTitleColor(.white, for: .normal)
            thirdButton.backgroundColor = UIColor.white
            thirdButton.setTitleColor(.black, for: .normal)
            break
        case 2:
            firstButton.backgroundColor = UIColor.white
            firstButton.setTitleColor(.black, for: .normal)
            secondButton.backgroundColor = UIColor.white
            secondButton.setTitleColor(.black, for: .normal)
            thirdButton.backgroundColor = UIColor(rgb: 0x25A4DA)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvaluateScreenFromNormalTest" {
            let destinationVc = segue.destination as! EvaluateViewController
            destinationVc.correctAnswers = test.correctAnswers
            destinationVc.numberOfQuestions = test.test.count
            destinationVc.modalPresentationStyle = .fullScreen
        }
    }

}
