//
//  OverlayView.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit

class OverlayView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    
    @IBOutlet weak var questionsNumberTextField: UITextField!
    
    @IBAction func onStartTestButtonTapped(_ sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        print(mainStoryBoard)
        
        guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController else {
            print("Could not find VC")
            return
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y > 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TestViewController
        destVC.numberOfQuestions = self.questionsNumberTextField.text!
    }
}
