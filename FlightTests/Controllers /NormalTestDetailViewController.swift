import UIKit

class NormalTestDetailViewController: UIViewController {
    
    var questions: [Question] = []
    var test = Test()
    var selectedAnswers: [Int: Int] = [:]
    var currentlySelectedButton: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(10))
        // Do any additional setup after loading the view.
    }
    
    func initTest(number: Int) -> [Question] {
        return Array(questions.choose(number))
    }
    
    @IBAction func onFirstButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 0
    }
    
    @IBAction func onSecondButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 1
    }
    
    @IBAction func onThirdButtonTapped(_ sender: UIButton) {
        self.currentlySelectedButton = 2
    }
    
    @IBAction func onNextQuestionButtonTapped(_ sender: UIButton) {
        self.selectedAnswers.updateValue(self.currentlySelectedButton, forKey: self.test.questionNumber)
        self.test.nextQuestion()
        self.updateUI()
    }
    
    @IBAction func onPreviousButtonTapped(_ sender: UIButton) {
        self.test.previousQuestion()
        self.updateUI()
    }
    
    func updateUI() {
    }

}
