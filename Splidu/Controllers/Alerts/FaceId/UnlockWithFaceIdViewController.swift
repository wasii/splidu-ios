//
//  UnlockWithFaceIdViewController.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit

class UnlockWithFaceIdViewController: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
//        mainView.applyGradient(isVertical: false, colorArray: [Color.customPink.color(), Color.customPurple.color()])
//        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Signup"), object: nil)
            })
        }
    }
}
