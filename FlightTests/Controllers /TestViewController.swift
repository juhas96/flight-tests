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
    
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(numberOfQuestions)!)
        self.setupQuestionLabel()
        self.updateUI()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    
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
    
    func setupQuestionLabel() {
        self.questionLabel.layer.cornerRadius = 20.0
        self.questionLabel.layer.masksToBounds = true
        self.questionLabel.textColor = .black
        self.questionLabel.sizeToFit()
    }
}

// Returns random N elements from array
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
