//
//  StatisticsViewController.swift
//  FlightTests
//
//  Created by Jakub Juh on 09/12/2020.
//

import UIKit
import Charts
import SQLite

class StatisticsViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    var db = DbHelper()
    var statistic = Statistics()
    var correctAnswersDataEntry = PieChartDataEntry(value: 0)
    var wrongAnswersDataEntry = PieChartDataEntry(value: 0)
    var numberOfAnswersDataEntry = [PieChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statistic = self.db.read()
        print(statistic)
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
    
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x2886BB)
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    
        self.updateChartData()
    }
    
    func updateChartData() {
        correctAnswersDataEntry.value = Double(statistic.correctAnswers)
        correctAnswersDataEntry.label = "Správne"
        wrongAnswersDataEntry.value = Double(statistic.wrongAnswers)
        wrongAnswersDataEntry.label = "Nesprávne"
        numberOfAnswersDataEntry = [correctAnswersDataEntry, wrongAnswersDataEntry]
        let chartDataSet = PieChartDataSet(entries: self.numberOfAnswersDataEntry, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.green, UIColor.red]
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChartView.data = chartData
        
    }
    
    
}
