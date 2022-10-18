//
//  UITextfield+Extension.swift
//  Splidu
//
//  Created by abdWasiq on 27/08/2022.
//

import Foundation
import UIKit

@IBDesignable
class UnderLineImageTextField: UITextField {
    override func draw(_ rect: CGRect) {
        
        let borderLayer = CALayer()
        let widthOfBorder = getBorderWidht()
        borderLayer.frame = CGRect(x: -15, y: self.frame.size.height - widthOfBorder, width: self.frame.size.width+20, height: self.frame.size.height)
        borderLayer.borderWidth = widthOfBorder
        borderLayer.borderColor = getBottomLineColor()
        self.layer.addSublayer(borderLayer)
        self.layer.masksToBounds = true
        
    }
    
    
    
    //MARK : set the image LeftSide
    @IBInspectable var SideImage:UIImage? {
        didSet{
            
            let leftAddView = UIView.init(frame: CGRect(x:0, y:0, width: 35, height: 20))
            let leftimageView = UIImageView.init(frame: CGRect(x:0, y:0, width: 25, height: 20))//Create a imageView for left side.
            leftimageView.image = SideImage
            leftAddView.addSubview(leftimageView)
            self.leftView = leftAddView
            self.leftViewMode = UITextField.ViewMode.always
        }
        
    }
    @IBInspectable var bottomLineColor: UIColor = UIColor.black {
        didSet {
            
        }
    }
    
    
    func getBottomLineColor() -> CGColor {
        return bottomLineColor.cgColor;
        
    }
    @IBInspectable var cusborderWidth:CGFloat = 1.0
        {
        didSet{
            
        }
    }
    
    func getBorderWidht() -> CGFloat {
        return cusborderWidth;
        
    }
}

private var __maxLengths = [UITextField: Int]()
extension UnderLineImageTextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return Int.max
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
