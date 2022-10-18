//
//  ProfileViewController.swift
//  Splidu
//
//  Created by Rafi on 02/09/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var arr = ["My Wallet", "My Order", "My Location", "Change Password", "LogOut"]
    
    var myProfile: MyProfileModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
                let url = URL(string: (self?.myProfile?.base_url ?? "") + (self?.myProfile?.user?.userImage ?? ""))
                self?.userImage.image = nil
                self?.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Default-Image"))

                self?.nameLabel.text =  "\(self?.myProfile?.user?.firstName ?? "--") \(self?.myProfile?.user?.lastName ?? "--")"
                self?.emailLabel.text = self?.myProfile?.user?.email ?? "--"
                self?.phoneLabel.text = (self?.myProfile?.user?.dialCode ?? "") + " " + (self?.myProfile?.user?.mobile ?? "--")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        type = .messages
        tableView.delegate = self
        tableView.dataSource = self
        getMyProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(getProfile), name: NSNotification.Name.init(rawValue: "UpdateMyProfile"), object: nil)
    }
    
    @objc func getProfile() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getMyProfile()
        }
    }
    
    private func getMyProfile() {
        let userId = SessionManager.getUserData()?.user?.id ?? 0
        ProfileAPIManager.GetMyProfile(userId: userId) { profile in
            switch profile.status {
            case "Success":
                self.myProfile = profile
                break
            case "Fail":
                break
            default: break
            }
        }
    }
  
    @IBAction func updateProfileBtn(_ sender: UIButton) {
        Coordinator.updateProfile(delegate: self, profile: myProfile)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        cell.titleLabel.text = arr[indexPath.row]
        if indexPath.row == 4 {
            cell.titleLabel.textColor = Color.customPink.color()
            cell.accessoryImgView.isHidden = true
        } else { cell.accessoryImgView.isHidden = false } 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Coordinator.wallet(delegate: self)
        } else if indexPath.row == 1 {
            Coordinator.openMyOrders(delegate: self)
        }
        else if indexPath.row == 2{
            Coordinator.showMyLocation(delegate: self)
        }
        else if indexPath.row == 3 {
            if SocialLogger.shared.isSocialLoginEnable() {
                Utilities.showWarningAlert(message: "Sorry! Unable to change password as you are currently logged in from your social media account")
                return
            }
            Coordinator.changePassword(delegate: self)
        }
        else if indexPath.row == 4{
            Coordinator.logout(delegate: self)
        }
        
    }
    
}
