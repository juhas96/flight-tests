import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var firstAnswerButton: AnswerButton!
    @IBOutlet weak var secondAnswerButton: AnswerButton!
    @IBOutlet weak var thirdAnswerButton: AnswerButton!
    
    let questions =
    [
        Question(text: "Základnými fyzikálnymi jednotkami podľa SI sú", answers: ["meter, kilogram, sekunda, ampér, kelvin, mol, kandela", "meter, kilogram, sekunda, kilopond, bar, kalória, gauss", "meter, decimeter, hodina, joule, watt, volt, ohm"], correctAnswerPosition: 0,testId: 1),
        Question(text: "Atmosféra alebo vzdušný obal zeme sa delí na štyri vrstvy. Najnižšia z nich - troposféra dosahuje do výšky asi", answers: ["8 km", "11,5 km", "13km"], correctAnswerPosition: 1,testId: 1),
        Question(text: "Ideálnym plynom rozumieme plyn", answers: ["nestlačiteľný, s vnútorným trením", "stlačiteľný, s vnútorným trením", "stlačiteľný, bez vnútorného trenia"], correctAnswerPosition: 1,testId: 1),
        Question(text: "Hybnosť hmotného bodu je definovaná", answers: ["m.v(m.kg.s-1)", "m.a(m.kg.s-2)", "m.t(kg.s)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Moment sily je definovaný", answers: ["moment M = G. l (kg. m)", "moment M = F. l (N. m)", "moment M = m. l (kg. m)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Mechanická práca je definovaná", answers: ["práca A = F. s (J)", "práca A = F. t (N. s)", "práca A = F. v (M. n. s-1)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Účinnosť je definovaná ako", answers: ["pomer príkonu k výkonu", "pomer výkonu k príkonu", "súčin príkonu a výkonu"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Sila je definovaná", answers: ["sila F = v. t (m)", "sila F = m. a (N)", "sila F = m. g (N)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Tiaž (sila tiaže) je definovaná", answers: ["G = m. g (N)", "G = m. v (m. kg. s-1)", "G = m.l (kg. m)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Výkon je definovaný", answers: ["výkon P = A / t (W)", "výkon P = A. t (m2. kg. s-3)", "výkon P = A. v (m3. kg. s-3)"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Rovnica spojitosti predstavuje určitú formu zákona", answers: ["zachovania hmoty", "zachovania energie", "akcie a reakcie"], correctAnswerPosition: 0, testId: 1),
        Question(text: "Bernoulliho rovnica vyjadruje zákon", answers: ["zachovania hmoty", "zachovania energie", "akcie a reakcie"], correctAnswerPosition: 0, testId: 1),
    ]
    
    
    var numberOfQuestions: String = ""
    var test = Test()

    override func viewDidLoad() {
        super.viewDidLoad()
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
