//
//  SidemenuViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit
import SideMenu
import SDWebImage

private enum Sections: String {
    case home = "Home"
    case ourStory = "Our Story"
    case faqs = "FAQs"
    case tc = "Terms & Conditions"
    case pp = "Privacy Policy"
    case help = "Help"
    case share = "Share"
    case rateApp = "Rate the App"
}
class SidemenuViewController: UIViewController {

    @IBOutlet weak var personImabe: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let sections: [Sections] = [
        .home,
        .ourStory,
        .faqs,
        .tc,
        .pp,
        .help,
        .share,
        .rateApp
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        if let userData = SessionManager.getUserData() {
            self.personName.text = "\(userData.user?.firstName ?? "") \(userData.user?.lastName ?? "")"
            if let image = userData.user?.userImage {
                if image != "" {
                    let url = URL(string: "\(userData.baseURL ?? "")\(userData.user?.userImage ?? "")")
                    personImabe.sd_setImage(with: url)
                    personImabe.ibcornerRadius = 10
                }
            }
        }
        
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: SideMenuTableCell.description(), bundle: nil), forCellReuseIdentifier: SideMenuTableCell.description())
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SidemenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableCell.description()) as! SideMenuTableCell
        cell.menuLabel.text = sections[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        switch self.sections[indexPath.row] {
        case .home: break
        case .ourStory:
            Coordinator.showOurStory(delegate: self)
        case .faqs: Coordinator.showFAQs(delegate: self)
        case .tc: Coordinator.showTermConditions(delegate: self)
        case .pp: Coordinator.showPrivacyPolicy(delegate: self)
        case .help: Coordinator.showHelp(delegate: self)
        case .share: break
        case .rateApp: break
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
