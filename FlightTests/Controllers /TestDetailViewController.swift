//
//  TestDetailViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 04/12/2020.
//

import UIKit

class TestDetailViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    
    var test: Question? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAnswerButtonTapped(_ sender: AnswerButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
