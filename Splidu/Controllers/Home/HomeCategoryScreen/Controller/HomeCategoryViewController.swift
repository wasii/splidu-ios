//
//  HomeCategoryViewController.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit
import FSPagerView
import SDWebImage

class HomeCategoryViewController: BaseViewController {

    @IBOutlet weak var nearByTopChefView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = 0
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.hidesForSinglePage = true
            self.pageControl.setImage(UIImage(named:"unselected-pagecontrol"), for: .normal)
            self.pageControl.setImage(UIImage(named:"selected-pagecontrol"), for: .selected)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainHeadingLabel: UILabel!
    //MARK: Variables
    var dining_data: [HomeDiningsData]?  {
        didSet {
            self.tableViewHeightConstraint.constant = CGFloat(210 * (self.dining_data?.count ?? 0))
            self.tableView.reloadData()
        }
    }
    
    var chef_data: [NearByChef]? {
        didSet {
            self.tableViewHeightConstraint.constant = CGFloat(210 * (self.chef_data?.count ?? 0))
            self.tableView.reloadData()
        }
    }
    
    var underground_chefs: UndergroundChefsModel? {
        didSet {
            self.baseUrl = underground_chefs?.baseURL ?? ""

        }
    }
    
    var nearByChefs: [NearByChef]? {
        didSet {
            if let count = nearByChefs?.count {
                if (count % 2) == 0 {
                    self.pageControl.numberOfPages = count / 2
                } else {
                    self.pageControl.numberOfPages = count
                }
                self.pageControl.currentPage = 0
                nearByTopChefView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    var baseUrl = ""
    var current_page: Int = 0
    var last_page: Int = 0
    var mainHeading: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        viewControllerTitle = mainHeading
        type = .backWithThreeButtons
        self.mainHeadingLabel.text = mainHeading
        NotificationCenter.default.post(name: .ChangeTabBarToBlack, object: nil, userInfo: nil)
        nearByTopChefView.isHidden = true
        getServerData(page: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.backgroundColor = UIColor.black
//        self.tabBarController?.tabBar.tintColor = UIColor.darkGray
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.backgroundColor = UIColor.white
//        self.tabBarController?.tabBar.tintColor = UIColor.black
//    }
    
    fileprivate func registerCells() {
        collectionView.register(UINib(nibName: NearByChefCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: NearByChefCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(UINib(nibName: HomeCategoryListingTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeCategoryListingTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableViewHeightConstraint.constant = 8 * 210
    }
    private func getServerData(page: String?) {
        HomeAPIManager.UndergroundChefs(page: page) { result in
            switch result.status {
            case "Success" :
                self.underground_chefs = result
                if let nearByChef = result.nearByChefs {
                    if let _ = self.nearByChefs {
                        self.nearByChefs?.append(contentsOf: nearByChef)
                    } else {
                        self.nearByChefs = nearByChef
                    }
                }
                if let _ = self.chef_data {
                    self.chef_data?.append(contentsOf: result.chefs?.data ?? [])
                } else {
                    self.chef_data = result.chefs?.data
                }
                self.current_page = result.chefs?.currentPage ?? 0// dining.dinings?.currentPage ?? 0
                self.last_page = result.chefs?.lastPage ?? 0// dining.dinings?.lastPage ?? 0
            case "Fail":
                Utilities.showWarningAlert(message: "Something went wrong")
                break
                
            default: break
            }
        }
    }
    @IBAction func filterBtnTapped(_ sender: Any) {
        Coordinator.showSearchFilterMenu(delegate: self)
    }
}


extension HomeCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.chef_data?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryListingTableCell.description()) as? HomeCategoryListingTableCell else {
            fatalError()
        }
        
        if let chef = self.chef_data?[indexPath.row] {
            cell.chefName.text = "\(chef.name ?? "")"
            //chef_cusines
            if let chef_cuisines = chef.chefCuisines {
                var cuisines = ""
                for (i, c) in chef_cuisines.enumerated() {
                    if i == chef_cuisines.endIndex - 1 {
                        cuisines += c.cuisine?.title ?? ""
                    } else {
                        cuisines += "\(c.cuisine?.title ?? ""), "
                    }
                }
                cell.cuisineName.text = cuisines
            }
//            cell.cuisineName.text = ""
            if let image = chef.chefMasterimage {
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
            cell.favoriteBtn.tintColor = .white
            cell.favoriteBtn.tag = indexPath.row
            cell.favoriteBtn.addTarget(self, action: #selector(addToFavourite(sender:)), for: .touchUpInside)
            if (chef.isFavourite ?? 0) == 0 {
                cell.favoriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                cell.favoriteBtn.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            }
            cell.shareBtn.tag = indexPath.row
            cell.shareBtn.addTarget(self, action: #selector(openShareSheet(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = self.chef_data?.count {
            if indexPath.row == count - 1 {
                if self.current_page != self.last_page {
                    self.getServerData(page: "\(self.current_page + 1)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.chef_data![indexPath.row]
        Coordinator.showHomeCategoryChefs(delegate: self, chefId: data.id, chefName: data.name)
    }
    @objc fileprivate func openShareSheet(sender: UIButton) {
//        let chefId = self.chef_data![sender.tag].id ?? 0
        let chefName = self.chef_data![sender.tag].name ?? ""
        
        Utilities.shareToOthers(shareText: chefName, sender: sender, delegate: self)
    }
    
    @objc fileprivate func addToFavourite(sender: UIButton) {
        Utilities.discardGuestUserSession()
        let chefId = self.chef_data![sender.tag].id ?? 0
        let isFavourite = self.chef_data![sender.tag].isFavourite ?? 0
        
        if isFavourite == 0 {
            let parameters = [
                "chef" : chefId,
                "type" : "chef"
            ] as [String:Any]
            FavouritesAPIManager.AddFavourites(paramater: parameters) { model in
                switch model.status {
                case "Success":
                    self.chef_data![sender.tag].isFavourite = 1
                    NotificationCenter.default.post(name: .FetchNewFavourites, object: nil)
                    break
                case "Fail":
                    Utilities.showWarningAlert(message: model.message ?? "")
                    break
                default: break
                }
            }
        } else {
            let parameters = [
                "type":"chef",
                "id": "\(chefId)"
            ] as [String:Any]
            FavouritesAPIManager.RemoveChefFavorite(parameters: parameters) { model in
                switch model.status {
                case "Success":
                    self.chef_data![sender.tag].isFavourite = 0
                    NotificationCenter.default.post(name: .FetchNewFavourites, object: nil)
                    break
                case "Fail":
                    break
                default: break
                }
            }
        }
    }
}


extension HomeCategoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.nearByChefs?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByChefCollectionCell.description(), for: indexPath) as? NearByChefCollectionCell else {
            fatalError()
        }
        if let nearChef = self.nearByChefs?[indexPath.row] {
            cell.chefName.text = nearChef.firstName ?? ""
            cell.chefCuisine.text = nearChef.brandName ?? ""
            if let chefImage = nearChef.profileImage {
                if chefImage == "" {
                    cell.chefImage.image = UIImage(named: "homeIcon")
                    cell.chefImage.contentMode = .scaleAspectFit
                } else {
                    let url = URL(string: baseUrl+chefImage)
                    print(url)
                    cell.chefImage.sd_setImage(with: url, placeholderImage: UIImage(named: "homeIcon"))
                    cell.chefImage.contentMode = .scaleAspectFill
                }
            } else {
                cell.chefImage.image = UIImage(named: "homeIcon")
                cell.chefImage.contentMode = .scaleAspectFit
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.nearByChefs![indexPath.row]
        Coordinator.showHomeCategoryChefs(delegate: self, chefId: data.id, chefName: data.name)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.bounds.size
        return CGSize(width: (size.width / 2) , height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

