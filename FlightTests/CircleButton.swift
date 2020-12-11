//
//  CircleButton.swift
//  FlightTests
//
//  Created by Jakub Juh on 05/12/2020.
//

import Foundation
import UIKit
import FontAwesome_swift

class CircleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .regular)
        self.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        self.sizeToFit()
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        self.layer.cornerRadius = 20.0
    }
}
