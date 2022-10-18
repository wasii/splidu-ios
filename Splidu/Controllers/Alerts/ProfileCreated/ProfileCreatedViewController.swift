//
//  ProfileCreatedViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit

class ProfileCreatedViewController: BaseViewController {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
        
        createBlur()
    }
    private func createBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualBlurEffect = UIVisualEffectView(effect: blurEffect)
        visualBlurEffect.frame = view.bounds
        visualBlurEffect.alpha = 0.5
        blurView.addSubview(visualBlurEffect)
    }
    
    @IBAction func startSpliduAppTapped(_ sender: Any) {
        Coordinator.showLetsExploreScreen(delegate: self)
    }
}
