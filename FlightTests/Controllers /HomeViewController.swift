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
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            if vc.isKind(of: HomeViewController.self) {
                return false
            } else {
                return true
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        setupAnimation()
        let parsedElektrotechnika = parse(jsonData: readLocalFile(forName: "elektrotechnika_new")!)
        let test_2 = parse(jsonData: readLocalFile(forName: "test_2_new")!)
        let parsedSpojovaciPredpis = parse(jsonData: readLocalFile(forName: "spojovaci_predpis_new")!)
        let parsedPalubnePristoje = parse(jsonData: readLocalFile(forName: "palubne_pristroje_new")!)
        let parsedLetoveVykony = parse(jsonData: readLocalFile(forName: "letove_vykony_new")!)
        let parsedLudskaVykonnost = parse(jsonData: readLocalFile(forName: "ludska_vykonnost_new")!)
        let parsedMedzinarodneLeteckePravo = parse(jsonData: readLocalFile(forName: "medzinarodne_letecke_pravo_new")!)
        let parsedLietadla = parse(jsonData: readLocalFile(forName: "lietadla_new")!)
        let parsedPostupyPreLetoveSluzby = parse(jsonData: readLocalFile(forName: "postupy_pre_letove_sluzby_new")!)
        let parsedLetiskaL14 = parse(jsonData: readLocalFile(forName: "letiska_l_14_new")!)
        let predpisyLetovychSluzieb = parse(jsonData: readLocalFile(forName: "predpisy_letovych_sluzieb_new")!)
        let prevadzkaLietadiel = parse(jsonData: readLocalFile(forName: "prevadzka_lietadiel_new")!)
        let pravidlaLietania = parse(jsonData: readLocalFile(forName: "pravidla_lietania_new")!)
        
        let data = parsedElektrotechnika + test_2 + parsedSpojovaciPredpis + parsedPalubnePristoje + parsedLetoveVykony + parsedLudskaVykonnost + parsedMedzinarodneLeteckePravo + parsedLietadla + parsedPostupyPreLetoveSluzby + parsedLetiskaL14 + predpisyLetovychSluzieb + prevadzkaLietadiel + pravidlaLietania
//
//        var testNames: Set<String> = []
//        leteckePravnePredpisy.forEach { (q) in
//            testNames.insert(q.testName)
//        }
//        
//        print(testNames.sorted())
        
        DataService.data.changeData(data: data)
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
            let textField = alert?.textFields![0]
            let vc = self.storyboard?.instantiateViewController(identifier: "TestViewController") as! TestViewController
            vc.numberOfQuestions = (textField?.text)!
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel, handler: nil))

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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        let htmlTemplate = """
            <!doctype html>
            <html>
              <head>
                <style>
                  body {
                    font-family: -apple-system;
                    font-size: 16px;
                    text-align: center;
                  }
                </style>
              </head>
              <body>
                \(self)
              </body>
            </html>
            """
        guard let data = htmlTemplate.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

