//
//  EvaluateViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 28/11/2020.
//

import UIKit

class EvaluateViewController: UIViewController {
    
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBAction func onHomeButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowHomeScreen", sender: self)
    }
    
    var numberOfQuestions = 0
    var correctAnswers = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        progressView?.progress = Float(correctAnswers) / Float(numberOfQuestions)
        correctAnswersLabel.text = "\(correctAnswers) / \(numberOfQuestions) si mal správne\n\(progressView.progress * 100)%"
        
        if (Float(correctAnswers) / Float(numberOfQuestions) * 100) >= 80 {
            self.evaluationLabel.textColor = .green
            self.evaluationLabel.text = "Gratulujeme v teste ste uspeli"
        } else {
            self.evaluationLabel.textColor = .red
            self.evaluationLabel.text = "Bohuzial testom ste nepresli"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHomeScreen" {
            let destinationVc = segue.destination as! HomeViewController
            destinationVc.modalPresentationStyle = .fullScreen
        }
    }
}
