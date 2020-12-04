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
    var userText: String = ""
    let questions = Table("questions")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let answers = Expression<String>("answers")
    let correctAnswerPosition = Expression<Int64>("correctAnswerPosition")
    let testId = Expression<Int64>("testId")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.connectToDb()
        let parsedData = parse(jsonData: readLocalFile(forName: "data")!)
        DataService.data.changeData(data: parsedData)
//        self.dataService.currentData.subscribe {data in print(data)}
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
    
    func connectToDb() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            self.database = try Connection("\(path)/db.sqlite3")
            try self.database.run(questions.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(answers)
                t.column(correctAnswerPosition)
            }))
            try self.database.run(questions.insert(name <- "testName", answers <- "Answers", correctAnswerPosition <- 1))

        } catch {
            print(error)
        }
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
