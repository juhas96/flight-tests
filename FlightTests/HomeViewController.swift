//
//  HomeViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit
import SQLite

class HomeViewController: UIViewController {
    
    var database: Connection!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        self.connectToDb()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onStartTestsButtonTapped(_ sender: UIButton) {
        showModal()
    }
    
    @objc func showModal() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    func connectToDb() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("questions").appendingPathComponent("sqlite3")
            let db = try Connection(fileUrl.path)
            self.database = db
        } catch {
            print(error)
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
