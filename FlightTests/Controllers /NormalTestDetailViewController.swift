import UIKit
import FontAwesome_swift
import SQLite


class NormalTestDetailViewController: UIViewController {
    
    var questions: [Question] = []
    var test = Test()
    var selectedAnswers: [Int: Int] = [:]
    var selectedAnswersWithIds: [String: Int] = [:]
    var currentlySelectedButton: Int = -1
    var correctAnswer: Int = -1
    var evaluationDict: [String: Int] = [:]
    var dbHelper = DbHelper()
    weak var buttonItem: UIBarButtonItem?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var nextButton: CircleButton!
    @IBOutlet weak var firstButton: AnswerButton!
    @IBOutlet weak var secondButton: AnswerButton!
    @IBOutlet weak var thirdButton: AnswerButton!
    @IBOutlet weak var questionTextLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(10))
        test.initFirstQuestionId()
        self.initUI()
        self.updateUI()
    }
    
    func initTest(number: Int) -> [Question] {
        // 1. step Group questions by category
        let groupedQuestions = Dictionary(grouping: questions) {
            $0.categoryName
        }
        
        var randomNineCategories: [String: [Question]] = [:]
        
        // 2. step
        while randomNineCategories.count < 9 {
            var random = groupedQuestions.randomElement()
            if (randomNineCategories[random!.key] == nil) {
                randomNineCategories.updateValue(random!.value, forKey: random!.key)
                evaluationDict.updateValue(0, forKey: random!.key)
            } else {
                random = groupedQuestions.randomElement()
            }
        }

        var testQuestions: [Question] = []
        
        for (_, q) in randomNineCategories {
            let tempQuestions = q.choose(10)
            testQuestions.append(contentsOf: tempQuestions)
        }
        
        return testQuestions
    }
    
    @objc func onEvalutateButtonTapped() {
        self.selectedAnswers.updateValue(self.currentlySelectedButton, forKey: self.test.questionNumber)
        self.selectedAnswersWithIds.updateValue(self.currentlySelectedButton, forKey: self.test.questionId)
        print(self.selectedAnswers.count)
        print(self.test.test.count)
        if (self.selectedAnswers.count < self.test.test.count) {
            let alert = UIAlertController(title: "Pred vyhodnotením musíš zodpovedať všetky otázky", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            for (questionPosition, answer) in selectedAnswers {
                self.test.checkAnswerOnPosition(userAnswer: answer, position: questionPosition)
            }
            
            let groupedQuestions = Dictionary(grouping: test.test) {
                $0.categoryName
            }
            
            for (category, questions) in groupedQuestions {
                for q in questions {
                    let categoryAndIfIsCorrect = self.test.checkAnswerWithId(userAnswer: selectedAnswersWithIds[q.id!]!, id: q.id!)
                    
                    if let isTrue = categoryAndIfIsCorrect[category] {
                        if (isTrue) {
                            let currentValue: Int? = self.evaluationDict[category]
                            self.evaluationDict.updateValue(currentValue! + 1, forKey: category)
                        }
                    }
                }
            }
            
            var questionIds = [String]()
            var userSelectedAnswers = [String]()
            
            for question in test.test {
                questionIds.append(question.id!)
            }
            
            for (_, value) in self.selectedAnswers {
                userSelectedAnswers.append(String(value))
            }
            
            print(self.evaluationDict)
            do {
                self.dbHelper.updateStatistics(correct: self.test.correctAnswers, wrong: self.test.wrongAnswers)
                self.dbHelper.insertIntoUserTests(test: UserTest(questionIds: questionIds, userAnswers: userSelectedAnswers))
            } catch {
                print(error)
            }
            
            self.performSegue(withIdentifier: "ShowEvaluateScreenFromNormalTest", sender: self)
        }
    }
    
    
    @IBAction func onFirstButtonTapped(_ sender: UIButton) {
        self.correctAnswer = self.test.test[test.questionNumber].correctAnswerPosition
        self.currentlySelectedButton = 0
        updateButtonsColor()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: false)
    }
    
    @IBAction func onSecondButtonTapped(_ sender: UIButton) {
        self.correctAnswer = self.test.test[test.questionNumber].correctAnswerPosition
        self.currentlySelectedButton = 1
        updateButtonsColor()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: false)
    }
    
    @IBAction func onThirdButtonTapped(_ sender: UIButton) {
        self.correctAnswer = self.test.test[test.questionNumber].correctAnswerPosition
        self.currentlySelectedButton = 2
        updateButtonsColor()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: false)
    }
    
    @IBAction func onNextQuestionButtonTapped(_ sender: UIButton) {
        self.selectedAnswers.updateValue(self.currentlySelectedButton, forKey: self.test.questionNumber)
        self.selectedAnswersWithIds.updateValue(self.currentlySelectedButton, forKey: self.test.questionId)
        self.test.nextQuestion()
        self.currentlySelectedButton = -1
        updateButtonsColor()
        self.updateUI()
    }
    
    @objc func nextQuestion() {
        self.selectedAnswers.updateValue(self.currentlySelectedButton, forKey: self.test.questionNumber)
        self.selectedAnswersWithIds.updateValue(self.currentlySelectedButton, forKey: self.test.questionId)
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
        
        self.title = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        if (test.getQuestionImage() != "") {
            imageView.isHidden = false
            imageView.image = UIImage(named: test.getQuestionImage())
        } else {
            imageView.isHidden = true
        }
        questionTextLabel.attributedText = test.getQuestionText().htmlToAttributedString
        questionTextLabel.textAlignment = .center
        questionTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        if let value = selectedAnswers[test.questionNumber] {
            self.currentlySelectedButton = value
        }
        firstButton?.setAttributedTitle(test.getAnswerOnPosition(position: 0).htmlToAttributedString, for: .normal)
        secondButton?.setAttributedTitle(test.getAnswerOnPosition(position: 1).htmlToAttributedString, for: .normal)
        thirdButton?.setAttributedTitle(test.getAnswerOnPosition(position: 2).htmlToAttributedString, for: .normal)
        updateButtonsColor()
        
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
            if (currentlySelectedButton == correctAnswer) {
                firstButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                firstButton.setTitleColor(.white, for: .normal)
                secondButton.backgroundColor = UIColor.white
                secondButton.setTitleColor(.black, for: .normal)
                thirdButton.backgroundColor = UIColor.white
                thirdButton.setTitleColor(.black, for: .normal)
            } else {
                firstButton.backgroundColor = UIColor(rgb: 0xec0101)
                firstButton.setTitleColor(.white, for: .normal)
                if (correctAnswer == 1) {
                    secondButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    secondButton.setTitleColor(.black, for: .normal)
                    thirdButton.backgroundColor = UIColor.white
                    thirdButton.setTitleColor(.black, for: .normal)
                } else if (correctAnswer == 2) {
                    secondButton.backgroundColor = UIColor.white
                    secondButton.setTitleColor(.black, for: .normal)
                    thirdButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    thirdButton.setTitleColor(.black, for: .normal)
                }
            }
            break
        case 1:
            if (currentlySelectedButton == correctAnswer) {
                secondButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                secondButton.setTitleColor(.white, for: .normal)
                firstButton.backgroundColor = UIColor.white
                firstButton.setTitleColor(.black, for: .normal)
                thirdButton.backgroundColor = UIColor.white
                thirdButton.setTitleColor(.black, for: .normal)
            } else {
                secondButton.backgroundColor = UIColor(rgb: 0xec0101)
                secondButton.setTitleColor(.white, for: .normal)
                if (correctAnswer == 0) {
                    firstButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    firstButton.setTitleColor(.black, for: .normal)
                    thirdButton.backgroundColor = UIColor.white
                    thirdButton.setTitleColor(.black, for: .normal)
                } else if (correctAnswer == 2) {
                    firstButton.backgroundColor = UIColor.white
                    firstButton.setTitleColor(.black, for: .normal)
                    thirdButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    thirdButton.setTitleColor(.black, for: .normal)
                }
            }
            break
        case 2:
            if (currentlySelectedButton == correctAnswer) {
                thirdButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                thirdButton.setTitleColor(.white, for: .normal)
                secondButton.backgroundColor = UIColor.white
                secondButton.setTitleColor(.black, for: .normal)
                firstButton.backgroundColor = UIColor.white
                firstButton.setTitleColor(.black, for: .normal)
            } else {
                thirdButton.backgroundColor = UIColor(rgb: 0xec0101)
                thirdButton.setTitleColor(.white, for: .normal)
                if (correctAnswer == 0) {
                    firstButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    firstButton.setTitleColor(.black, for: .normal)
                    secondButton.backgroundColor = UIColor.white
                    secondButton.setTitleColor(.black, for: .normal)
                } else if (correctAnswer == 1) {
                    firstButton.backgroundColor = UIColor.white
                    firstButton.setTitleColor(.black, for: .normal)
                    secondButton.backgroundColor = UIColor(rgb: 0x5fbb97)
                    secondButton.setTitleColor(.black, for: .normal)
                }
            }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Vyhodnotiť test", style: .plain, target: self, action: #selector(onEvalutateButtonTapped))

        self.nextButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.nextButton.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        
        self.backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.backButton.setTitle(String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
        
        self.title = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setupQuestionLabel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvaluateScreenFromNormalTest" {
            let destinationVc = segue.destination as! EvaluateViewController
            destinationVc.correctAnswers = test.correctAnswers
            destinationVc.numberOfQuestions = test.test.count
            destinationVc.groupedCorrectQuestions = self.evaluationDict
            destinationVc.modalPresentationStyle = .fullScreen
        }
    }

}
