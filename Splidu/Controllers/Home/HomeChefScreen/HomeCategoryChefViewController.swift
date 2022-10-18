//
//  HomeCategoryChefViewController.swift
//  Splidu
//
//  Created by abdWasiq on 31/08/2022.
//

import UIKit

class HomeCategoryChefViewController: BaseViewController {

    @IBOutlet weak var noDiningLabel: UILabel!
    @IBOutlet weak var mainChefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefBrand: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ratingView: UIView!
    private let myCollectionViewFlowLayout = MyCollectionViewFlowLayout()
    
    var centerCell: NearByChefCollectionCell?
    
    
    var chefId: Int?
    var pageTitle = ""
    
    var current_page: Int = 0
    var last_page: Int = 0
    
    let data = [
        UIImage(named: "maleChef")!,
        UIImage(named: "femaleChef")!,
        UIImage(named: "randomChef1")!,
        UIImage(named: "randomChef2")!,
        UIImage(named: "randomChef3")!,
        UIImage(named: "Rectangle 17626")!
    ]
    
    var chefDetail: UndergroundChefDetailModel? {
        didSet {
            self.baseUrl = chefDetail?.baseURL ?? ""
        }
    }
    var chef: Chef? {
        didSet {
            chefName.text = chef?.name ?? ""
            chefBrand.text = chef?.brandName ?? ""
            if let chefImage = chef?.chefMasterimage {
                if chefImage == "" {
                    if let firstSlider = chef?.chefImages?.first {
                        let url = URL(string: baseUrl + (firstSlider.path ?? ""))
                        self.mainChefImage.sd_setImage(with: url)
                        self.mainChefImage.contentMode = .scaleToFill
                    } else {
                        self.mainChefImage.image = UIImage(named: "homeIcon")
                        self.mainChefImage.contentMode = .scaleAspectFit
                    }
                } else {
                    let url = URL(string: baseUrl+chefImage)
                    mainChefImage.sd_setImage(with: url)//, placeholderImage: <#T##UIImage?#>)
                }
            }
            collectionView.reloadData()
        }
    }
    var chefDiningDetail: [ChefDiningDetails]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var baseUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithThreeButtons
        viewControllerTitle = pageTitle
        view.isHidden = true
        registerCells()
        getServerData(page: nil)
    }
    private func getServerData(page: String?) {
        HomeAPIManager.UndergroundChefsDetails(chefId: chefId ?? 0, page: page) { result in
            switch result.status {
            case "Success":
                self.view.isHidden = false
                self.baseUrl = result.baseURL ?? ""
                self.chef = result.chef
                if let _ = self.chefDiningDetail {
                    self.chefDiningDetail?.append(contentsOf: result.chefDinings?.chefDinigDetail ?? [])
                } else {
                    self.chefDiningDetail = result.chefDinings?.chefDinigDetail
                }
                self.current_page = result.chefDinings?.currentPage ?? 0
                self.last_page = result.chefDinings?.lastPage ?? 0
                break
            case "Fail":
                break
            default: break
            }
        }
    }
    
    fileprivate func registerCells() {
        tableView.register(UINib(nibName: HomeCategoryListingTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeCategoryListingTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.register(UINib(nibName: NearByChefCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: NearByChefCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self.myCollectionViewFlowLayout
    }
    @IBAction func filterBtnTapped(_ sender: Any) {
        Coordinator.showSearchFilterMenu(delegate: self)
    }
}

extension HomeCategoryChefViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.chefDiningDetail?.count {
            if count > 0 {
                self.tableView.isHidden = false
                self.noDiningLabel.isHidden = true
            }
            return count
        }
        self.tableView.isHidden = true
        self.noDiningLabel.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryListingTableCell.description()) as? HomeCategoryListingTableCell else {
            fatalError()
        }
//        cell.discountView.isHidden = false
        if let chef_data = self.chefDiningDetail?[indexPath.row] {
            cell.chefName.text = chef_data.title ?? ""
            cell.cuisineName.text = chef_data.slug ?? ""
            cell.discountView.isHidden = false
            
            cell.shareBtn.tag = indexPath.row
            cell.shareBtn.addTarget(self, action: #selector(openShareSheet(sender:)), for: .touchUpInside)
            
            cell.favoriteBtn.tintColor = .white
            cell.favoriteBtn.tag = indexPath.row
            cell.favoriteBtn.addTarget(self, action: #selector(addToFavourite(sender:)), for: .touchUpInside)
            if (chef_data.isFavourite ?? 0) == 0 {
                cell.favoriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                cell.favoriteBtn.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            }
            if let image = chef_data.image {
                if image == "" {
                    cell.chefImage.image = UIImage(named: "homeIcon")
                    cell.chefImage.contentMode = .scaleAspectFit
                } else {
                    let url = URL(string:baseUrl + image)
                    cell.chefImage.sd_setImage(with: url, placeholderImage: cell.chefImage.image)
                }
                cell.chefImage.contentMode = .scaleAspectFill
            } else {
                cell.chefImage.image = UIImage(named: "homeIcon")
                cell.chefImage.contentMode = .scaleAspectFit
            }
            
            if let dicountPrice = chef_data.discountPrice {
                if dicountPrice == "" {
                    cell.newPrice.text = "AED \(chef_data.pricePerson ?? "")"
                    cell.oldPrice.text = ""
                } else {
                    let discountPrice = Double(chef_data.pricePerson ?? "0")
                    let actualPrice = Double(chef_data.discountPrice ?? "0")
                    
//                    let finalPrice = (actualPrice ?? 0.0) - (discountPrice ?? 0.0)
                    
                    cell.oldPrice.text = String(format: "AED %.0f", actualPrice ?? 0.0)
                    cell.newPrice.text = String(format: "AED %.0f", discountPrice ?? 0.0)
            
                }
            } else {
                cell.newPrice.text = "\(chef_data.pricePerson ?? "")"
                cell.oldPrice.text = ""
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = self.chefDiningDetail?.count {
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
        let chefId = self.chefDiningDetail![indexPath.row].id ?? 0
        let chefName = self.chefDiningDetail![indexPath.row].title ?? ""
        Coordinator.showHomeCategoryChefsDetail(delegate: self, chefId: chefId, chefName: chefName)
    }
    @objc fileprivate func openShareSheet(sender: UIButton) {
        let chefName = self.chefDiningDetail![sender.tag].title ?? ""
        
        Utilities.shareToOthers(shareText: chefName, sender: sender, delegate: self)
    }
    @objc fileprivate func addToFavourite(sender: UIButton) {
        Utilities.discardGuestUserSession()
        let chefId = self.chefDiningDetail![sender.tag].id ?? 0
        let isFavourite = self.chefDiningDetail![sender.tag].isFavourite ?? 0
        
        if isFavourite == 0 {
            let parameters = [
                "chef" : chefId,
                "type" : "chef"
            ] as [String:Any]
            FavouritesAPIManager.AddFavourites(paramater: parameters) { model in
                switch model.status {
                case "Success":
                    self.chefDiningDetail![sender.tag].isFavourite = 1
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
                    self.chefDiningDetail![sender.tag].isFavourite = 0
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


extension HomeCategoryChefViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.chef?.chefImages?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByChefCollectionCell.description(), for: indexPath) as? NearByChefCollectionCell else {
            fatalError()
        }
        cell.gradientImage.isHidden = true
        cell.chefImage.ibcornerRadius = 5
        cell.chefImage.borderColor = .white
        cell.chefImage.borderWidth = 1
        cell.chefName.text = ""
        cell.chefCuisine.text = ""
        if let data = self.chef?.chefImages?[indexPath.row] {
            if let image = data.path {
                if image == "" {
                    cell.chefImage.image = UIImage(named: "homeIcon")
                    cell.chefImage.contentMode = .scaleToFill
                } else {
                    let url = URL(string: baseUrl+image)
                    cell.chefImage.sd_setImage(with: url) //, placeholderImage: <#T##UIImage?#>)
                    cell.chefName.contentMode = .scaleToFill
                }
            } else {
                cell.chefImage.image = UIImage(named: "homeIcon")
                cell.chefImage.contentMode = .scaleToFill
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let gallery = self.chef?.chefImages?[indexPath.row] {
            let url = URL(string: baseUrl + (gallery.path ?? ""))
            self.mainChefImage.sd_setImage(with: url)
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 67, height: 73)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView is UICollectionView else { return }
//        let centerPoint = CGPoint(x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
//                                  y: self.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
//
//        if let indexPath = self.collectionView.indexPathForItem(at: centerPoint) {
//            self.centerCell = (self.collectionView.cellForItem(at: indexPath) as! NearByChefCollectionCell)
//            self.centerCell?.transformToLarge()
//        }
//
//        if let cell = self.centerCell {
//            let offSetX = centerPoint.y - cell.center.y
//            if offSetX < 10 {
//                cell.transformToStandard()
//                self.centerCell = nil
//            }
//        }
//    }
}




final class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .vertical
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        itemSize = CGSize(width: 77, height: 83)
    }
}
