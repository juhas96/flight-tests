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
    }
}
