//
//  LetsExploreViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit

class LetsExploreViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func exploreBtnTapped(_ sender: Any) {
        Coordinator.gotoTabBar()
    }
}
