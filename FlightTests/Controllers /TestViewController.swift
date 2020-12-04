import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: AnswerButton!
    @IBOutlet weak var secondAnswerButton: AnswerButton!
    @IBOutlet weak var thirdAnswerButton: AnswerButton!
    
    var questions: [Question] = []
    
    
    var numberOfQuestions: String = ""
    var test = Test()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(numberOfQuestions)!)
        self.updateUI()
    
    }
    
    @IBAction func onAnswerButtonTapped(_ sender: UIButton) {
        let isAnswerRight = self.test.checkAnswer(userAnswer: sender.tag)
        if isAnswerRight {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        test.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
        print(test.questionNumber)
        print(Int(numberOfQuestions)!)
        if test.questionNumber == Int(numberOfQuestions)! {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showEvaluateScreen), userInfo: nil, repeats: false)
        }
    }
    
    @objc func showEvaluateScreen() {
        self.performSegue(withIdentifier: "ShowEvaluateScreen", sender: self)
    }
    
    @objc func updateUI() {
        questionLabel?.text = test.getQuestionText()
        progressBar?.progress = test.getProgress()
        progressLabel?.text = "\(test.questionNumber + 1) / \(test.test.count)"
        
        firstAnswerButton?.backgroundColor = UIColor.white
        secondAnswerButton?.backgroundColor = UIColor.white
        thirdAnswerButton?.backgroundColor = UIColor.white
        
        firstAnswerButton?.setTitle(test.getAnswerOnPosition(position: 0), for: UIControl.State.normal)
        secondAnswerButton?.setTitle(test.getAnswerOnPosition(position: 1), for: UIControl.State.normal)
        thirdAnswerButton?.setTitle(test.getAnswerOnPosition(position: 2), for: UIControl.State.normal)
    }
    
    
    func initTest(number: Int) -> [Question] {
        return Array(questions.choose(number))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvaluateScreen" {
            let destinationVc = segue.destination as! EvaluateViewController
            destinationVc.correctAnswers = test.correctAnswers
            destinationVc.numberOfQuestions = test.test.count
            destinationVc.modalPresentationStyle = .fullScreen
        }
        
    }
}

// Returns random N elements from array
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
