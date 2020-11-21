import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: AnswerButton!
    @IBOutlet weak var secondAnswerButton: AnswerButton!
    @IBOutlet weak var thirdAnswerButton: AnswerButton!
    
    
    var numberOfQuestions: String = ""
    var test = Test()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @objc func updateUI() {
        questionLabel.text = test.getQuestionText()
        progressBar.progress = test.getProgress()
        progressLabel.text = "\(test.questionNumber + 1) / \(test.test.count)"
        
        firstAnswerButton.backgroundColor = UIColor.white
        secondAnswerButton.backgroundColor = UIColor.white
        thirdAnswerButton.backgroundColor = UIColor.white
        
        firstAnswerButton.setTitle(test.getAnswerOnPosition(position: 0), for: UIControl.State.normal)
        secondAnswerButton.setTitle(test.getAnswerOnPosition(position: 1), for: UIControl.State.normal)
        thirdAnswerButton.setTitle(test.getAnswerOnPosition(position: 2), for: UIControl.State.normal)
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
