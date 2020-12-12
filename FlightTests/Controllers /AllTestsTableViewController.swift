//
//  AllTestsTableViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit
import RxSwift

class AllTestsTableViewController: UITableViewController {
    
    
    let disposeBag = DisposeBag()
    let cellId = "singleTestId"
    
    let allTests = [
        ["Aerodynamika A 1", "Aerodynamika A 2", "Aerodynamika A 3", "Aerodynamika A 4", "Aerodynamika A 5", "Aerodynamika A 6","Aerodynamika A 7","Aerodynamika A 8","Aerodynamika A 9","Aerodynamika A 10","Aerodynamika A 11","Aerodynamika A 12","Aerodynamika A 13","Aerodynamika A 14","Aerodynamika A 15","Aerodynamika A 16","Aerodynamika A 17","Aerodynamika A 18","Aerodynamika A 19","Aerodynamika A 20","Aerodynamika A 21","Aerodynamika B 1","Aerodynamika B 2","Aerodynamika B 3","Aerodynamika B 4","Aerodynamika B 5","Aerodynamika B 6","Aerodynamika B 7","Aerodynamika B 8","Aerodynamika B 9","Aerodynamika B 10","Aerodynamika B 11","Aerodynamika B 12","Aerodynamika X63", "Aerodynamika X64", "Aerodynamika X65", "Aerodynamika X66", "Aerodynamika X67", "Aerodynamika X68", "Aerodynamika X69", "Aerodynamika X70", "Aerodynamika X71", "Aerodynamika Y63", "Aerodynamika Y64", "Aerodynamika Y65", "Aerodynamika Y66", "Aerodynamika Y67", "Aerodynamika Y68", "Aerodynamika Y69", "Aerodynamika Y70", "Aerodynamika Y71"],
        ["Elektrotechnika A 1","Elektrotechnika A 2","Elektrotechnika A 3","Elektrotechnika A 4","Elektrotechnika A 5","Elektrotechnika A 6","Elektrotechnika A 7","Elektrotechnika A 8","Elektrotechnika A 9","Elektrotechnika A 10","Elektrotechnika B 1","Elektrotechnika B 2","Elektrotechnika B 3","Elektrotechnika B 4","Elektrotechnika B 5","Elektrotechnika B 6","Elektrotechnika X11", "Elektrotechnika X12", "Elektrotechnika Y11", "Elektrotechnika Y12", "Elektrotechnika Y13"]
    ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Všetky testy"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
//        print(self.dataService.getData())
//        self.disposeBag.insert(self.dataService.currentData.subscribe {data in print(data)})
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let text = self.allTests[section][0].split(separator: " ")[0]
        label.text = String(text)
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.setMargins(margin: 10)
        label.backgroundColor = .white
        label.textColor = .black
        
        return label
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allTests.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTests[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = self.allTests[indexPath.section][indexPath.row]
        cell.textLabel?.text = name
        cell.textLabel?.textColor = .black
        cell.contentView.backgroundColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as? TestDetailViewController
        
        // TODO: send data
        vc?.testName = allTests[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
