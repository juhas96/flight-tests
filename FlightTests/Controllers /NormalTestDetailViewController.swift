import UIKit

class NormalTestDetailViewController: UIViewController {
    
    var questions: [Question] = []
    var test = Test()
    var selectedAnswers: [Int: Int] = [:]
    var currentlySelectedButton: Int = -1
    
    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var nextButton: CircleButton!
    @IBOutlet weak var firstButton: AnswerButton!
    @IBOutlet weak var secondButton: AnswerButton!
    @IBOutlet weak var thirdButton: AnswerButton!
    @IBOutlet weak var questionTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(10))
        self.updateUI()
    }
    
    func initTest(number: Int) -> [Question] {
        return Array(questions.choose(number))
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
        
        self.questionNumberLabel.text = "Question \(test.questionNumber + 1) / \(test.test.count)"
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
            firstButton.backgroundColor = UIColor.green
            secondButton.backgroundColor = UIColor.white
            thirdButton.backgroundColor = UIColor.white
            break
        case 1:
            firstButton.backgroundColor = UIColor.white
            secondButton.backgroundColor = UIColor.green
            thirdButton.backgroundColor = UIColor.white
            break
        case 2:
            firstButton.backgroundColor = UIColor.white
            secondButton.backgroundColor = UIColor.white
            thirdButton.backgroundColor = UIColor.green
            break
        default:
            firstButton.backgroundColor = UIColor.white
            secondButton.backgroundColor = UIColor.white
            thirdButton.backgroundColor = UIColor.white
            break
        }
    }

}
