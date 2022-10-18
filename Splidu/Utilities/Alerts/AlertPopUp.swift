//
//  AlertPopUp.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import UIKit

class AlertPopUp: UIView {
    @IBAction func okayButtonAction(_ sender: Any) {
        dismiss()
        if let _ = okayAction {
            okayAction!()
        }
    }
    
    var okayAction: (()->())?
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var dialogueBoxView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    var message: String? {
        didSet {
            messageLabel.text = message ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tag = 999
        messageLabel.textColor = UIColor.black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func instanceFromNib() -> AlertPopUp {
        return UINib(nibName: "AlertPopUp", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertPopUp
    }
    
    func show() {
        overlayView.alpha = 0
        dialogueBoxView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        if let oldAlert = keyWindow.viewWithTag(999) {
            oldAlert.removeFromSuperview()
        }
        keyWindow.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0.5
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.dialogueBoxView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}
