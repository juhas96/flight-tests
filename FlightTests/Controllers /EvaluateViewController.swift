//
//  EvaluateViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 28/11/2020.
//

import UIKit

class EvaluateViewController: UIViewController {
    
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBAction func onHomeButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    var numberOfQuestions = 0
    var correctAnswers = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        progressView?.progress = Float(correctAnswers) / Float(numberOfQuestions)
        correctAnswersLabel.text = "\(correctAnswers) / \(numberOfQuestions) si mal správne\n\(progressView.progress * 100)%"
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowMainPage" {
//            let destinationVc = segue.destination as! HomeViewController
//            destinationVc.modalPresentationStyle = .fullScreen
//        }
//    }
}
