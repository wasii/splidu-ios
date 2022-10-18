//
//  FilterViewController.swift
//  Splidu
//
//  Created by Wahyd Pvt Ltd on 06/09/2022.
//

import UIKit

class FilterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .searchFilter
        viewControllerTitle = "Filters"
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
//        NotificationCenter.default.post(name: .HideBottomBarButton, object: nil, userInfo: ["isHidden": true])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToBlack, object: nil)
//        NotificationCenter.default.post(name: .HideBottomBarButton, object: nil, userInfo: ["isHidden": false])
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDateClicked(_ sender: Any) {
        Coordinator.showSearchDateMenu(delegate: self)
    }
    
    @IBAction func btnDietaryClicked(_ sender: Any) {
        Coordinator.showSearchDietaryMenu(delegate: self)
    }
    
    @IBAction func btnCuisineClicked(_ sender: Any) {
        Coordinator.showSearchCusisineMenu(delegate: self)
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        Coordinator.showSearchLocationMenu(delegate: self)
    }
    
    @IBAction func btnOfferClicked(_ sender: Any) {
        Coordinator.showSearchOfferMenu(delegate: self)
    }
    
    @IBAction func btnRatingClicked(_ sender: Any) {
        Coordinator.showSearchRatingMenu(delegate: self)
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
    }
    
}
