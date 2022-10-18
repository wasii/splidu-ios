//
//  SearchViewController.swift
//  Splidu
//
//  Created by Muhammad Waqas Rafeeq on 05/09/2022.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.post(name: .ChangeTabBarToBlack, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    
    @IBAction func btnSortingClicked(_ sender: Any) {
    }
    
    @IBAction func btnFilterClicked(_ sender: Any) {
        Coordinator.showSearchFilterMenu(delegate: self)
    }
}

extension SearchViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else { return UITableViewCell() }
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        
        if indexPath.row == 0 {
            cell.imgSearch.image = UIImage(named: "s1")
            cell.imgBadge.image = UIImage(named: "")
        }
        else if indexPath.row == 1 {
            cell.imgSearch.image = UIImage(named: "s2")
            cell.imgBadge.image = UIImage(named: "")
        }
        else if indexPath.row == 2 {
            cell.iconHeart.isHidden = true
            cell.imgSearch.image = UIImage(named: "s3")
            cell.imgBadge.image = UIImage(named: "")
        }
        else if indexPath.row == 3 {
            cell.iconHeart.isHidden = true
            cell.imgSearch.image = UIImage(named: "s4")
            cell.imgBadge.image = UIImage(named: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
