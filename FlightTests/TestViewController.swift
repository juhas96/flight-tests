//
//  TestViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var firstChoiceButton: AnswerButton!
    @IBOutlet weak var secondChoiceButton: AnswerButton!
    @IBOutlet weak var thirdChoiceButton: AnswerButton!

    @IBOutlet weak var questionText: UITextView!
    
    
    var numberOfQuestions: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        questionText.text = "Ak lietadlo nepriletelo na cieľové letisko počas 10 minút od vypočítaného času naposledy oznámeného alebo vypočítaného stanoviskom riadenia letovej prevádzky, oblastné stredisko oznámi záchrannému koordinačnému stredisku obdobie"
        
        firstChoiceButton.setTitle("Neistoty", for: .normal)
        secondChoiceButton.setTitle("Tiesne", for: .normal)
        thirdChoiceButton.setTitle("Pohotovosti", for: .normal)
    }
    
    @IBAction func onFirstChoiceButtonTapped(_ sender: UIButton) {
        firstChoiceButton.backgroundColor = .red
    }
    
    @IBAction func onSecondChoiceButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func onThirdChoiceButtonTapped(_ sender: UIButton) {
    }
}
