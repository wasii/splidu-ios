//
//  ShowMenuViewController.swift
//  Splidu
//
//  Created by NaheedPK on 26/09/2022.
//

import UIKit
import SDWebImage
class ShowMenuViewController: UIViewController {

    @IBOutlet weak var menuImg: UIImageView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let Url = URL(string: url)
            menuImg.sd_setImage(with: Url)
            menuImg.contentMode = .scaleAspectFit
            
            menuImg.ibcornerRadius = 15
        }
    }
}
