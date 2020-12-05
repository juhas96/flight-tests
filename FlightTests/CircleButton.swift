//
//  CircleButton.swift
//  FlightTests
//
//  Created by Jakub Juh on 05/12/2020.
//

import Foundation
import UIKit

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
        self.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
