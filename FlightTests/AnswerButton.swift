import UIKit

enum ButtonState {
    case normal
    case selected
}

class AnswerButton: UIButton {
    
    var buttonState: ButtonState = .normal
    
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
        if (buttonState == .normal) {
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
        } else if (buttonState == .selected) {
            backgroundColor = UIColor(rgb: 0x25A4DA)
            setTitleColor(.white, for: .normal)
        }
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        self.sizeToFit()
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    
        titleLabel?.font = UIFont(name: "Arial", size: 14)
        layer.cornerRadius = 20
    }
}
