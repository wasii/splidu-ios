//
//  FavoritesViewController.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var chefGradient: UIImageView!
    @IBOutlet weak var experienceGradient: UIImageView!
    
    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var chefTableView: UITableView!
    var baseUrl = ""
    var favourite_chef: FavouritesChefModel? {
        didSet {
            baseUrl = favourite_chef?.base_url ?? ""
            self.chefTableView.reloadData()
        }
    }
    var favorited_experienced: FavouriteDiningModel? {
        didSet {
            baseUrl = favourite_chef?.base_url ?? ""
            self.experienceTableView.reloadData()
        }
    }
    var isChef = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        registerCells()
        getFavouritesChef()
        getFavouriteDinings()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .FetchNewFavourites, object: nil)
    }
    @objc private func reload() {
        getFavouritesChef()
        getFavouriteDinings()
    }
    private func registerCells() {
        chefTableView.register(UINib(nibName: HomeCategoryListingTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeCategoryListingTableCell.description())
        chefTableView.delegate = self
        chefTableView.dataSource = self
        
        experienceTableView.register(UINib(nibName: HomeCategoryListingTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeCategoryListingTableCell.description())
        experienceTableView.delegate = self
        experienceTableView.dataSource = self
    }
    private func getFavouritesChef() {
        let parameter = [
            "type": "chef"
        ]
        FavouritesAPIManager.GetFavouritesChef(parameter: parameter) { chef in
            switch chef.status {
            case "Success":
                self.favourite_chef = chef
            default:break
            }
        }
    }
    
    private func getFavouriteDinings() {
        let parameter = [
            "type" : "dining"
        ]
        FavouritesAPIManager.GetFavouritesDining(parameter: parameter) { dining in
            switch dining.status {
            case "Success":
                self.favorited_experienced = dining
                break
            default: break
            }
        }
    }
    
    @IBAction func optionSelectionTapped(_ sender: UIButton) {
        chefTableView.isHidden = true
        experienceTableView.isHidden = true
        if sender.tag == 0 {
            chefGradient.isHidden = false
            experienceGradient.isHidden = true
            if let _ = self.favourite_chef {
                self.chefTableView.isHidden = false
            }
        } else {
            experienceGradient.isHidden = false
            chefGradient.isHidden = true
            if let _ = self.favorited_experienced {
                self.experienceTableView.isHidden = false
            }
        }
    }
}
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 15
        if tableView == chefTableView {
            if let count = self.favourite_chef?.length {
                return count
            }
        } else {
            if let count = self.favorited_experienced?.length {
                return count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryListingTableCell.description()) as! HomeCategoryListingTableCell
        
        if tableView == chefTableView {
            let data = self.favourite_chef?.data?[indexPath.row]
            cell.chefName.text = data?.chef?.name ?? ""
            cell.cuisineName.text = data?.chef?.welcomeDescription ?? ""
            cell.favoriteBtn.addTarget(self, action: #selector(removeFavChef(sender:)), for: .touchUpInside)
            cell.favoriteBtn.tag = indexPath.row
            
            
            if let image = data?.chef?.userImage {
                if image == "" {
                    cell.chefImage.image = UIImage(named: "homeIcon")
                    cell.chefImage.contentMode = .scaleAspectFit
                } else {
                    let url = URL(string: baseUrl+image)
                    print(url)
                    cell.chefImage.sd_setImage(with: url, placeholderImage: UIImage(named: "homeIcon"))
                    cell.chefImage.contentMode = .scaleToFill
                }
                cell.chefImage.contentMode = .scaleAspectFill
            } else {
                cell.chefImage.image = UIImage(named: "homeIcon")
                cell.chefImage.contentMode = .scaleAspectFit
            }
        } else {
            let data = self.favorited_experienced?.data?[indexPath.row]
            cell.chefName.text = data?.dining?.title ?? ""
            cell.cuisineName.text = data?.dining?.slug ?? ""
            cell.favoriteBtn.addTarget(self, action: #selector(removeFavExperience(sender:)), for: .touchUpInside)
            cell.favoriteBtn.tag = indexPath.row
            
            if let image = data?.dining?.diningImage {
                if image == "" {
                    cell.chefImage.image = UIImage(named: "homeIcon")
                    cell.chefImage.contentMode = .scaleAspectFit
                } else {
                    let url = URL(string: baseUrl+image)
                    print(url)
                    cell.chefImage.sd_setImage(with: url, placeholderImage: UIImage(named: "homeIcon"))
                    cell.chefImage.contentMode = .scaleToFill
                }
                cell.chefImage.contentMode = .scaleAspectFill
            } else {
                cell.chefImage.image = UIImage(named: "homeIcon")
                cell.chefImage.contentMode = .scaleAspectFit
            }
        }
        
        cell.ratingView.isHidden = false
        cell.shareBtn.isHidden = true
        cell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.favoriteBtn.tintColor = .white
        return cell
    }
    
    @objc func removeFavChef(sender:UIButton) {
        if let id = self.favourite_chef?.data?[sender.tag].chef?.id {
            let params = [
                "type": "chef",
                "id" : "\(id)"
            ] as [String:Any]
            FavouritesAPIManager.RemoveFavouritesChef(params: params) { model in
                switch model.status {
                case "Success":
                    Utilities.showSuccessAlert(message: model.message ?? "") {
                        self.getFavouritesChef()
                    }
                    break
                case "Fail":
                    Utilities.showSuccessAlert(message: model.message ?? "")
                    break
                default: break
                }
            }
        }
    }
    @objc func removeFavExperience(sender:UIButton) {
        if let id = self.favorited_experienced?.data?[sender.tag].dining?.id {
            let params = [
                "type": "dining",
                "id" : "\(id)"
            ] as [String:Any]
            FavouritesAPIManager.RemoveFavouritesChef(params: params) { model in
                switch model.status {
                case "Success":
                    Utilities.showSuccessAlert(message: model.message ?? "") {
                        self.getFavouriteDinings()
                    }
                    break
                case "Fail":
                    Utilities.showSuccessAlert(message: model.message ?? "")
                    break
                default: break
                }
            }
        }
    }
}

