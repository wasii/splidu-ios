//
//  CuisineViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class CuisineViewController: BaseViewController {

    @IBOutlet weak var imgCheckAll: UIImageView!
        @IBOutlet weak var imgItalianCheck: UIImageView!
        @IBOutlet weak var imgIndianCheck: UIImageView!
        @IBOutlet weak var imgJapneseCheck: UIImageView!
        @IBOutlet weak var imgChineseCheck: UIImageView!
        @IBOutlet weak var imgFrenchCheck: UIImageView!
        @IBOutlet weak var imgThaiCheck: UIImageView!
        @IBOutlet weak var imgTurkishCheck: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerTitle = "Select Cuisine"
        type = .backBlack
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    
    @IBAction func btnCheckAllClicked(_ sender: Any) {
        if imgCheckAll.image == UIImage(named: "checkBox-Uncheck") {
                    imgCheckAll.image = UIImage(named: "checkBox-Check")
                    imgItalianCheck.image = UIImage(named: "checkBox-Check")
                    imgIndianCheck.image = UIImage(named: "checkBox-Check")
                    imgJapneseCheck.image = UIImage(named: "checkBox-Check")
                    imgChineseCheck.image = UIImage(named: "checkBox-Check")
                    imgFrenchCheck.image = UIImage(named: "checkBox-Check")
                    imgThaiCheck.image = UIImage(named: "checkBox-Check")
                    imgTurkishCheck.image = UIImage(named: "checkBox-Check")
                }
                else {
                    imgCheckAll.image = UIImage(named: "checkBox-Uncheck")
                    imgItalianCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgIndianCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgJapneseCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgChineseCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgFrenchCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgThaiCheck.image = UIImage(named: "checkBox-Uncheck")
                    imgTurkishCheck.image = UIImage(named: "checkBox-Uncheck")
                }
    }
    @IBAction func btnItalianCheckClicked(_ sender: Any) {
        if imgItalianCheck.image == UIImage(named: "checkBox-Check") {
                    imgItalianCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgItalianCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    
    @IBAction func btnIndianCheckClicked(_ sender: Any) {
        if imgIndianCheck.image == UIImage(named: "checkBox-Check") {
                    imgIndianCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgIndianCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    @IBAction func btnJapneseCheckClicked(_ sender: Any) {
        if imgJapneseCheck.image == UIImage(named: "checkBox-Check") {
                    imgJapneseCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgJapneseCheck.image = UIImage(named: "checkBox-Check")
                }

    }
    
    @IBAction func btnChineseCheckClicked(_ sender: Any) {
        if imgChineseCheck.image == UIImage(named: "checkBox-Check") {
                    imgChineseCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgChineseCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    
    @IBAction func btnFrenchCheckClicked(_ sender: Any) {
        if imgFrenchCheck.image == UIImage(named: "checkBox-Check") {
                    imgFrenchCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgFrenchCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    @IBAction func btnThaiCheckClicked(_ sender: Any) {
        if imgThaiCheck.image == UIImage(named: "checkBox-Check") {
                    imgThaiCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgThaiCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    @IBAction func btnTurkeshCheckClicked(_ sender: Any) {
        if imgTurkishCheck.image == UIImage(named: "checkBox-Check") {
                    imgTurkishCheck.image = UIImage(named: "checkBox-Uncheck")
                }
                else {
                    imgTurkishCheck.image = UIImage(named: "checkBox-Check")
                }
    }
    
}
