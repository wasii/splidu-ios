//
//  DietaryViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class DietaryViewController: BaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
        @IBOutlet weak var imgCheckAll: UIImageView!
        @IBOutlet weak var gultenCheckbox: UIImageView!
        @IBOutlet weak var halalCheckbox: UIImageView!
        @IBOutlet weak var organicCheckbox: UIImageView!
        @IBOutlet weak var veganCheckbox: UIImageView!
        @IBOutlet weak var vegeCheckbox: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Dietary"
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    
    @IBAction func selectAllTapped(_ sender: Any) {
    }
    
    @IBAction func btnCheckAllClicked(_ sender: Any) {
            if imgCheckAll.image == UIImage(named: "checkBox-Check") {
                imgCheckAll.image = UIImage(named: "checkBox-Uncheck")
                gultenCheckbox.image = UIImage(named: "checkBox-Uncheck")
                halalCheckbox.image = UIImage(named: "checkBox-Uncheck")
                organicCheckbox.image = UIImage(named: "checkBox-Uncheck")
                veganCheckbox.image = UIImage(named: "checkBox-Uncheck")
                vegeCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                imgCheckAll.image = UIImage(named: "checkBox-Check")
                gultenCheckbox.image = UIImage(named: "checkBox-Check")
                halalCheckbox.image = UIImage(named: "checkBox-Check")
                organicCheckbox.image = UIImage(named: "checkBox-Check")
                veganCheckbox.image = UIImage(named: "checkBox-Check")
                vegeCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnGlutenCheckClicked(_ sender: Any) {
            if gultenCheckbox.image == UIImage(named: "checkBox-Check") {
                gultenCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                gultenCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnHalalCheckClicked(_ sender: Any) {
            if halalCheckbox.image == UIImage(named: "checkBox-Check") {
                halalCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                halalCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnOrganicCheckClicked(_ sender: Any) {
            if organicCheckbox.image == UIImage(named: "checkBox-Check") {
                organicCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                organicCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnVeganCheckClicked(_ sender: Any) {
            if veganCheckbox.image == UIImage(named: "checkBox-Check") {
                veganCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                veganCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
        
        @IBAction func btnVegCheckClicked(_ sender: Any) {
            if vegeCheckbox.image == UIImage(named: "checkBox-Check") {
                vegeCheckbox.image = UIImage(named: "checkBox-Uncheck")
            }
            else {
                vegeCheckbox.image = UIImage(named: "checkBox-Check")
            }
        }
    
}
