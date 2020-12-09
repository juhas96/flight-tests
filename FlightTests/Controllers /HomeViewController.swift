//
//  HomeViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit
import SQLite
import Lottie

class HomeViewController: UIViewController {
    
    var database: Connection!
    var userText: String = ""
    var dbHelper = DbHelper()
    @IBOutlet weak var planeAnimationView: AnimationView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(rgb: 0x2886BB).cgColor, UIColor(rgb: 0x25CCF0).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect.zero
            return gradientLayer
        }()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.view.bounds
        
        setupAnimation()
        let stat = self.dbHelper.read()
        print("\(stat.wrongAnswers)")
        let parsedData = parse(jsonData: readLocalFile(forName: "data")!)
        DataService.data.changeData(data: parsedData)
    }
    
    private func setupAnimation() {
        planeAnimationView.animation = Animation.named("plane")
        planeAnimationView.loopMode = .loop
        planeAnimationView.play()
    }
    
    @IBAction func onStartTestsButtonTapped(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Koľko otázok chcete vygenerovať?", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "2"
            textField.keyboardType = .numberPad
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            var textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            let vc = self.storyboard?.instantiateViewController(identifier: "TestViewController") as! TestViewController
            vc.numberOfQuestions = (textField?.text)!
            self.present(vc, animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) -> [Question] {
        do {
            let decodedData = try JSONDecoder().decode([Question].self,
                                                       from: jsonData)
            
            return decodedData
        } catch {
            print(error)
        }
        return []
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

