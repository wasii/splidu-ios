//
//  RatingViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class RatingViewController: BaseViewController {
    @IBOutlet weak var imgCheckAll: UIImageView!
    @IBOutlet weak var imgGoodCheck: UIImageView!
    @IBOutlet weak var imgVeryGoodCheck: UIImageView!
    @IBOutlet weak var imgEndlessCheck: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Rating"
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    @IBAction func btnCheckAllClicked(_ sender: Any) {
        if imgCheckAll.image == UIImage(named: "checkBox-Check") {
            imgCheckAll.image = UIImage(named: "checkBox-Uncheck")
            imgGoodCheck.image = UIImage(named: "checkBox-Uncheck")
            imgVeryGoodCheck.image = UIImage(named: "checkBox-Uncheck")
            imgEndlessCheck.image = UIImage(named: "checkBox-Uncheck")
        }
        else {
            imgCheckAll.image = UIImage(named: "checkBox-Check")
            imgGoodCheck.image = UIImage(named: "checkBox-Check")
            imgVeryGoodCheck.image = UIImage(named: "checkBox-Check")
        }
    }
    @IBAction func btnGoodCheckClicked(_ sender: Any) {
        if imgGoodCheck.image == UIImage(named: "checkBox-Check") {
            imgGoodCheck.image = UIImage(named: "checkBox-Uncheck")
        }
        else {
            imgGoodCheck.image = UIImage(named: "checkBox-Check")
        }
    }
    
    @IBAction func btnVeryGoodCheckClicked(_ sender: Any) {
        if imgVeryGoodCheck.image == UIImage(named: "checkBox-Check") {
            imgVeryGoodCheck.image = UIImage(named: "checkBox-Uncheck")
        }
        else {
            imgVeryGoodCheck.image = UIImage(named: "checkBox-Check")
        }
    }
    @IBAction func btnEndlessCheckClicked(_ sender: Any) {
        if imgEndlessCheck.image == UIImage(named: "checkBox-Check") {
            imgEndlessCheck.image = UIImage(named: "checkBox-Uncheck")
        }
        else {
            imgEndlessCheck.image = UIImage(named: "checkBox-Check")
        }
    }
}
