//
//  AnswerButton.swift
//  FlightTests
//
//  Created by Jakub Juh on 18/11/2020.
//

import UIKit

class AnswerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    
        titleLabel?.font = UIFont(name: "Arial", size: 24)
        layer.cornerRadius = 15
    }
}
