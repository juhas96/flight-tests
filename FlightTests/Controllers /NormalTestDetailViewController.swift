import UIKit
import FontAwesome_swift
import SQLite


class NormalTestDetailViewController: UIViewController {
    
    var questions: [Question] = []
    var test = Test()
    var selectedAnswers: [Int: Int] = [:]
    var selectedAnswersWithIds: [String: Int] = [:]
    var currentlySelectedButton: Int = -1
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
        
        self.questions = DataService.data.getData()
        test.test = self.initTest(number: Int(10))
        test.initFirstQuestionId()
        self.title = "Otázka \(test.questionNumber + 1) / \(test.test.count)"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateUI()
        self.setupQuestionLabel()
    }
    
    func initTest(number: Int) -> [Question] {
        // 1. step Group questions by category
        let groupedQuestions = Dictionary(grouping: questions) {
            $0.categoryName
        }
        
        var randomNineCategories: [String: [Question]] = [:]
        
        // 2. step
        while randomNineCategories.count < 2 {
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
            
            print(self.evaluationDict)
            do {
                self.dbHelper.update(correct: self.test.correctAnswers, wrong: self.test.wrongAnswers)
            } catch {
                print(error)
            }
            
            self.performSegue(withIdentifier: "ShowEvaluateScreenFromNormalTest", sender: self)
        }
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
    
    func setupQuestionLabel() {
        self.questionTextLabel.layer.cornerRadius = 20.0
        self.questionTextLabel.layer.masksToBounds = true
        self.questionTextLabel.textColor = .black
        self.questionTextLabel.sizeToFit()
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
