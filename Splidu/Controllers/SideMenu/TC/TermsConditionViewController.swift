//
//  TermsConditionViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class TermsConditionViewController: BaseViewController {

    @IBOutlet weak var tcLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Terms & Condition"
        getTermsAndConditions()
    }
    private func getTermsAndConditions() {
        SideMenuAPIManager.GetCMSPages(type: "terms-and-conditions") { cmsmodel in
            switch cmsmodel.status {
            case "Success":
                self.tcLabel.text = cmsmodel.data?.descEn ?? ""
                break
            case "Fail":
                break
            default: break
            }
        }
    }
}
