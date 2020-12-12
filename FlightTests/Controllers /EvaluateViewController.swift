//
//  EvaluateViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 28/11/2020.
//

import UIKit
import Lottie

class EvaluateViewController: UIViewController {
    
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBAction func onHomeButtonTapped(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "ShowHomeScreen", sender: self)
    }
    @IBOutlet weak var animationView: AnimationView!
    
    var numberOfQuestions = 0
    var correctAnswers = 0
    
    var groupedCorrectQuestions: [String:Int] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.evaluationLabel.text = ""
        if (groupedCorrectQuestions.count > 0) {
            for (category, correctAnswers) in groupedCorrectQuestions {
                self.evaluationLabel.text?.append("\(category): \(correctAnswers)/10\n")
            }
        } else {
            self.evaluationLabel.text = "\(correctAnswers)/\(numberOfQuestions) správnych"
        }
        
        var gradietLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            if (Float(correctAnswers) / Float(numberOfQuestions) * 100) >= 80 {
                gradientLayer.colors = [UIColor(rgb: 0x14DD28).cgColor, UIColor(rgb: 0x3EBB2A).cgColor]
            } else {
                gradientLayer.colors = [UIColor(rgb: 0xE72525).cgColor, UIColor(rgb: 0x821818).cgColor]
            }
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect.zero
            return gradientLayer
        }()
        if (Float(correctAnswers) / Float(numberOfQuestions) * 100) >= 80 {
            self.animationView.animation = Animation.named("thumbsup")
            self.animationView.loopMode = .playOnce
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.play()
        } else {
            self.animationView.animation = Animation.named("sad-face")
            self.animationView.loopMode = .loop
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.play()
        }
        self.setupQuestionLabel()
        self.view.layer.insertSublayer(gradietLayer, at: 0)
        gradietLayer.frame = self.view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHomeScreen" {
            let destinationVc = segue.destination as! HomeViewController
            destinationVc.modalPresentationStyle = .fullScreen
        }
    }
    
    func setupQuestionLabel() {
        self.evaluationLabel.layer.cornerRadius = 20.0
        self.evaluationLabel.layer.masksToBounds = true
        self.evaluationLabel.textColor = .black
        self.evaluationLabel.sizeToFit()
    }
}
