//
//  AllTestsTableViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit

class AllTestsTableViewController: UITableViewController {
    
    let cellId = "singleTestId"
    
    let allTests = [["Aerodynamika X63", "Aerodynamika X64", "Aerodynamika X65", "Aerodynamika X66", "Aerodynamika X67"],
                    ["Elektrotechnika X11", "Elektrotechnika X12", "Elektrotechnika X13", "Elektrotechnika X14"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Všetky testy"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let text = self.allTests[section][0].split(separator: " ")[0]
        label.text = String(text)
        label.setMargins(margin: 10)
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allTests.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTests[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = self.allTests[indexPath.section][indexPath.row]
        cell.textLabel?.text = name
        
        return cell
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
