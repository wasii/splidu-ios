//
//  LocationViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class LocationViewController: BaseViewController {
    @IBOutlet weak var imgCheckAll: UIImageView!
        @IBOutlet weak var imgBusinessCheck: UIImageView!
        @IBOutlet weak var imgDownCheck: UIImageView!
        @IBOutlet weak var imgDubaieCheck: UIImageView!
        @IBOutlet weak var imgBasktiyaCheck: UIImageView!
        @IBOutlet weak var imgKarmaCheckClicked: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Choose Location"
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    
    @IBAction func btnCheckAllClicked(_ sender: Any) {
            if imgCheckAll.image == UIImage(named: "checkBox-Check") {
                imgCheckAll.image = UIImage(named: "checkBox-Uncheck")
                imgBusinessCheck.image = UIImage(named: "checkBox-Uncheck")
                imgDownCheck.image = UIImage(named: "checkBox-Uncheck")
                imgDubaieCheck.image = UIImage(named: "checkBox-Uncheck")
                imgBasktiyaCheck.image = UIImage(named: "checkBox-Uncheck")
                imgKarmaCheckClicked.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgCheckAll.image = UIImage(named: "checkBox-Check")
                imgBusinessCheck.image = UIImage(named: "checkBox-Check")
                imgDownCheck.image = UIImage(named: "checkBox-Check")
                imgDubaieCheck.image = UIImage(named: "checkBox-Check")
                imgBasktiyaCheck.image = UIImage(named: "checkBox-Check")
                imgKarmaCheckClicked.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnBusinessCheckClicked(_ sender: Any) {
            if imgBusinessCheck.image == UIImage(named: "checkBox-Check") {
                imgBusinessCheck.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgBusinessCheck.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnDownCheckClicked(_ sender: Any) {
            if imgDownCheck.image == UIImage(named: "checkBox-Check") {
                imgDownCheck.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgDownCheck.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnDubaieCheckClicked(_ sender: Any) {
            if imgDubaieCheck.image == UIImage(named: "checkBox-Check") {
                imgDubaieCheck.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgDubaieCheck.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnBastakiyaCheckClicked(_ sender: Any) {
            if imgBasktiyaCheck.image == UIImage(named: "checkBox-Check") {
                imgBasktiyaCheck.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgBasktiyaCheck.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnKarmaCheckClicked(_ sender: Any) {
            if imgKarmaCheckClicked.image == UIImage(named: "checkBox-Check") {
                imgKarmaCheckClicked.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgKarmaCheckClicked.image = UIImage(named: "checkBox-Check")
            }
        }

}
