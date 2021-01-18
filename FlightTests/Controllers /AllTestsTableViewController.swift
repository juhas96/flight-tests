//
//  AllTestsTableViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit
import RxSwift

struct TestCategory {
    var categoryName: String
    var tests: [String]
}

class AllTestsTableViewController: UITableViewController {
    
    
    let disposeBag = DisposeBag()
    let cellId = "singleTestId"
    
    let allTests: [TestCategory] = [
        TestCategory(categoryName: "Elektrotechnika", tests: ["Elektrotechnika 1", "Elektrotechnika 10", "Elektrotechnika 2", "Elektrotechnika 3", "Elektrotechnika 4", "Elektrotechnika 5", "Elektrotechnika 6", "Elektrotechnika 7", "Elektrotechnika 8", "Elektrotechnika 9", "Elektrotechnika B 1", "Elektrotechnika B 2", "Elektrotechnika B 3", "Elektrotechnika B 4", "Elektrotechnika B 5", "Elektrotechnika B 6", "Elektrotechnika X11 - letecký test", "Elektrotechnika X12 - letecký test", "Elektrotechnika X13 - letecký test", "Elektrotechnika Y11 - letecký test", "Elektrotechnika Y12 - letecký test", "Elektrotechnika Y13 - letecký test"]),
        TestCategory(categoryName: "Letecká Angličtina", tests: ["Bezpečnosť a nehody", "Letecká angličtina B 1", "Letecká angličtina B 2", "Letecká angličtina B 3", "Letecká angličtina B 4", "Letecká angličtina B 5", "Letecká angličtina B 6", "Letecká angličtina B 7", "Letecká angličtina B 8", "Letecká angličtina B 9", "Letové vlastnosti", "Lietanie", "Motory", "Nádrže", "Stavba lietadla", "Stavba lietadla 2", "Vojenská terminológia", "Vojenská terminológia 2", "Údržba lietadla"]),
        TestCategory(categoryName: "Letecká doprava", tests: ["Letecká doprava", "Spôsobilosť leteckého personálu", "Spôsobilosť leteckého personálu 2", "Spôsobilosť leteckého personálu B 1", "Spôsobilosť leteckého personálu B 2"]),
        TestCategory(categoryName: "Letecké Pohonné jednotky", tests: ["Letecké pohonné jednotky X31 - letecký test", "Letecké pohonné jednotky X32 - letecký test", "Letecké pohonné jednotky X33 - letecký test", "Letecké pohonné jednotky X34 - letecký test", "Letecké pohonné jednotky X35 - letecký test", "Letecké pohonné jednotky Y31 - letecký test", "Letecké pohonné jednotky Y32 - letecký test", "Letecké pohonné jednotky Y33 - letecký test", "Letecké pohonné jednotky Y34 - letecký test", "Letecké pohonné jednotky Y35 - letecký test"]),
        TestCategory(categoryName: "Letiská L-14", tests: ["Letiská L-14 Y46 - letecký test", "Letiská L-14 Y47 - letecký test", "Letiská L-14 X46 - letecký test", "Letiská L-14 X47 - letecký test"]),
        TestCategory(categoryName: "Postupy - Prevádzkové služby", tests: ["Postupy pre letové prevádzkové služby L-4444 X41", "Postupy pre letové prevádzkové služby L-4444 X42", "Postupy pre letové prevádzkové služby L-4444 X43", "Postupy pre letové prevádzkové služby L-4444 X44", "Postupy pre letové prevádzkové služby L-4444 X45", "Postupy pre letové prevádzkové služby L-4444 Y41", "Postupy pre letové prevádzkové služby L-4444 Y42", "Postupy pre letové prevádzkové služby L-4444 Y43", "Postupy pre letové prevádzkové služby L-4444 Y44", "Postupy pre letové prevádzkové služby L-4444 Y45"]),
        TestCategory(categoryName: "Pravidlá lietania L-2", tests: ["Pravidlá lietania L-2 X56", "Pravidlá lietania L-2 X57", "Pravidlá lietania L-2 X58", "Pravidlá lietania L-2 X59", "Pravidlá lietania L-2 X60", "Pravidlá lietania L-2 X61", "Pravidlá lietania L-2 X62", "Pravidlá lietania L-2 Y56", "Pravidlá lietania L-2 Y57", "Pravidlá lietania L-2 Y58", "Pravidlá lietania L-2 Y59", "Pravidlá lietania L-2 Y60", "Pravidlá lietania L-2 Y61", "Pravidlá lietania L-2 Y62"]),
        TestCategory(categoryName: "Predpis o LPS L-11", tests: ["Predpis o letových prevádzkových službách L-11 X48", "Predpis o letových prevádzkových službách L-11 X49", "Predpis o letových prevádzkových službách L-11 X50", "Predpis o letových prevádzkových službách L-11 X51", "Predpis o letových prevádzkových službách L-11 X52", "Predpis o letových prevádzkových službách L-11 Y48", "Predpis o letových prevádzkových službách L-11 Y49", "Predpis o letových prevádzkových službách L-11 Y50", "Predpis o letových prevádzkových službách L-11 Y51", "Predpis o letových prevádzkových službách L-11 Y52"]),
        TestCategory(categoryName: "Prevádzka Lietadiel L-6/II", tests: ["Prevádzka lietadiel L-6/II. X53", "Prevádzka lietadiel L-6/II. X54", "Prevádzka lietadiel L-6/II. X55", "Prevádzka lietadiel L-6/II. Y53", "Prevádzka lietadiel L-6/II. Y54", "Prevádzka lietadiel L-6/II. Y55"]),
        TestCategory(categoryName: "Meteorológia", tests: ["Meteorológia 1", "Meteorológia 10", "Meteorológia 11", "Meteorológia 12", "Meteorológia 13", "Meteorológia 14", "Meteorológia 15", "Meteorológia 2", "Meteorológia 3", "Meteorológia 4", "Meteorológia 5", "Meteorológia 6", "Meteorológia 7", "Meteorológia 8", "Meteorológia 9", "Meteorológia B 1", "Meteorológia B 2", "Meteorológia B 3", "Meteorológia B 4", "Meteorológia B 5", "Meteorológia B 6", "Meteorológia B 7", "Meteorológia B 8", "Meteorológia B 9", "Meteorológia X24 - letecký test", "Meteorológia X25 - letecký test", "Meteorológia X26 - letecký test", "Meteorológia X27 - letecký test", "Meteorológia X28 - letecký test", "Meteorológia X29 - letecký test", "Meteorológia X30 - letecký test", "Meteorológia Y24 - letecký test", "Meteorológia Y25 - letecký test", "Meteorológia Y26 - letecký test", "Meteorológia Y27 - letecký test", "Meteorológia Y28 - letecký test", "Meteorológia Y29 - letecký test", "Meteorológia Y30 - letecký test"]),
        TestCategory(categoryName: "Palubné prístroje", tests: ["Palubné prístroje 1", "Palubné prístroje 10", "Palubné prístroje 11", "Palubné prístroje 12", "Palubné prístroje 13", "Palubné prístroje 14", "Palubné prístroje 15", "Palubné prístroje 16", "Palubné prístroje 17", "Palubné prístroje 2", "Palubné prístroje 3", "Palubné prístroje 4", "Palubné prístroje 5", "Palubné prístroje 6", "Palubné prístroje 7", "Palubné prístroje 8", "Palubné prístroje 9", "Palubné prístroje B 1", "Palubné prístroje B 10", "Palubné prístroje B 11", "Palubné prístroje B 2", "Palubné prístroje B 3", "Palubné prístroje B 4", "Palubné prístroje B 5", "Palubné prístroje B 6", "Palubné prístroje B 7", "Palubné prístroje B 8", "Palubné prístroje B 9", "Palubné prístroje X05 - letecký test", "Palubné prístroje X06 - letecký test", "Palubné prístroje X07 - letecký test", "Palubné prístroje X08 - letecký test", "Palubné prístroje X09 - letecký test", "Palubné prístroje X10 - letecký test", "Palubné prístroje Y05 - letecký test", "Palubné prístroje Y06 - letecký test", "Palubné prístroje Y07 - letecký test", "Palubné prístroje Y08 - letecký test", "Palubné prístroje Y09 - letecký test", "Palubné prístroje Y10 - letecký test"]),
        TestCategory(categoryName: "Spojovací predpis a komunikácia", tests: ["Spojovací predpis 1", "Spojovací predpis 10", "Spojovací predpis 11", "Spojovací predpis 12", "Spojovací predpis 13", "Spojovací predpis 14", "Spojovací predpis 15", "Spojovací predpis 16", "Spojovací predpis 2", "Spojovací predpis 3", "Spojovací predpis 4", "Spojovací predpis 5", "Spojovací predpis 6", "Spojovací predpis 7", "Spojovací predpis 8", "Spojovací predpis 9", "Spojovací predpis B1", "Spojovací predpis B10", "Spojovací predpis B11", "Spojovací predpis B2", "Spojovací predpis B3", "Spojovací predpis B4", "Spojovací predpis B5", "Spojovací predpis B6", "Spojovací predpis B7", "Spojovací predpis B8", "Spojovací predpis B9", "Spojovací predpis X72", "Spojovací predpis X73", "Spojovací predpis X74", "Spojovací predpis X75", "Spojovací predpis X76", "Spojovací predpis X77", "Spojovací predpis Y72", "Spojovací predpis Y73", "Spojovací predpis Y74", "Spojovací predpis Y75", "Spojovací predpis Y76", "Spojovací predpis Y77"]),
        TestCategory(categoryName: "Rádiotechnika", tests: ["Rádiotechnika 1", "Rádiotechnika 10", "Rádiotechnika 11", "Rádiotechnika 2", "Rádiotechnika 3", "Rádiotechnika 4", "Rádiotechnika 5", "Rádiotechnika 6", "Rádiotechnika 7", "Rádiotechnika 8", "Rádiotechnika 9", "Rádiotechnika B 1", "Rádiotechnika B 2", "Rádiotechnika B 3", "Rádiotechnika B 4", "Rádiotechnika B 5", "Rádiotechnika B 6", "Rádiotechnika B 7", "Rádiotechnika X01", "Rádiotechnika X02", "Rádiotechnika X03", "Rádiotechnika X04", "Rádiotechnika Y1", "Rádiotechnika Y2", "Rádiotechnika Y3", "Rádiotechnika Y4"]),
        TestCategory(categoryName: "Letecké právne predpisy", tests: ["Letecké právne predpisy 1", "Letecké právne predpisy 2", "Letecké právne predpisy 3", "Letecké právne predpisy 4", "Letecké právne predpisy 5", "Letecké právne predpisy 6", "Letecké právne predpisy 7", "Letecké právne predpisy B 1", "Letecké právne predpisy B 2", "Letecké právne predpisy B 3", "Letecké právne predpisy X22 - letecký test", "Letecké právne predpisy X23 - letecký test", "Letecké právne predpisy Y22 - letecký test", "Letecké právne predpisy Y23 - letecký test"])
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
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        let text = self.allTests[section].categoryName
//        label.text = String(text)
//        label.font = UIFont.boldSystemFont(ofSize: 24.0)
//        label.setMargins(margin: 10)
//        label.backgroundColor = .white
//        label.textColor = .black
//
//        return label
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = self.allTests[indexPath.row].categoryName
        cell.textLabel?.text = name
        cell.textLabel?.textColor = .black
        cell.contentView.backgroundColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as? TestDetailViewController
        
        // TODO: send data
        vc?.testName = allTests[indexPath.row].categoryName
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
