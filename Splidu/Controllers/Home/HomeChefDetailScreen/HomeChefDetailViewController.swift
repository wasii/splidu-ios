//
//  HomeChefDetailViewController.swift
//  Splidu
//
//  Created by abdWasiq on 31/08/2022.
//

import UIKit
import SDWebImage

class HomeChefDetailViewController: BaseViewController {

    @IBOutlet weak var accepRejectView: UIStackView!
    @IBOutlet weak var bookNowView: UIView!
    
    
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var pricePersonLabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var slugLabel: UILabel!
    @IBOutlet weak var mainChefImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chefCollectionView: UICollectionView!
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    @IBOutlet weak var cuisineHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var allergensCollectionView: UICollectionView!
    @IBOutlet weak var allergensHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    
    
    @IBOutlet weak var cancellationPolicyViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancellationPolicyTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancellationPolicyTableView: UITableView!
    
    @IBOutlet weak var experienceSummaryLabel: UILabel!
    @IBOutlet weak var guidlinesLabel: UILabel!
    @IBOutlet weak var logisticsLabel: UILabel!
    
    var chefId: Int?
    var pageTitle = ""
    var baseURL = ""
    var chefDetail: HomeChefDetailModel? {
        didSet {
            self.baseURL = self.chefDetail?.baseURL ?? ""
            if let appbanner = self.chefDetail?.dining?.appBannerAttachment {
                if appbanner == "" {
                    if let gallery = self.chefDetail?.dining?.gallery?.first {
                        let url = URL(string: baseURL+(gallery.image ?? ""))
                        self.mainChefImage.sd_setImage(with: url)
                    } else {
                        self.mainChefImage.image = UIImage(named: "homeIcon")
                    }
                } else {
                    let url = URL(string: baseURL + appbanner)
                    self.mainChefImage.sd_setImage(with: url)
                }
                self.mainChefImage.contentMode = .scaleToFill
            } else {
                self.mainChefImage.image = UIImage(named: "homeIcon")
                self.mainChefImage.contentMode = .scaleToFill
            }
            self.titlelabel.text = self.chefDetail?.dining?.title ?? ""
            self.slugLabel.text = self.chefDetail?.dining?.slug ?? ""
            self.oldPrice.text = "AED \(self.chefDetail?.dining?.discountPrice ?? "")"
            self.pricePersonLabel.text = "AED \(self.chefDetail?.dining?.pricePerson ?? "")"
            
            let font = UIFont(name: "Nunito-Regular", size: 15)!
            
            self.experienceSummaryLabel.text = self.chefDetail?.dining?.experienceSummary ?? ""
            let exHeight = self.experienceSummaryLabel.text?.height(
                withConstrainedWidth: (self.experienceSummaryLabel.frame.size.width),
                font: font
            )
            self.logisticsLabel.text = self.chefDetail?.dining?.logisticInformation ?? ""
            let logHeight = self.logisticsLabel.text?.height(
                withConstrainedWidth: (self.logisticsLabel.frame.size.width),
                font: font
            )
            self.guidlinesLabel.text = "\(self.chefDetail?.dining?.guidelinesInformation ?? "")"
            let gHeight = self.guidlinesLabel.text?.height(
                withConstrainedWidth: (self.guidlinesLabel.frame.size.width),
                font: font
            )
            let menu_data = (self.chefDetail?.dining?.menuDescription ?? "").split(separator: "\n")
            self.menudata = menu_data.map { "\u{2022} \(String($0))" }
            self.menuTableView.reloadData()
            self.menuTableViewHeightConstraint.constant = CGFloat(menudata.count * 20)
            
            if chefDetail?.dining?.discountPrice == nil {
                self.oldPrice.isHidden = true
                self.pricePersonLabel.text = "AED \(chefDetail?.dining?.pricePerson ?? "0.0")"
            } else {
                self.oldPrice.isHidden = false
                
                let discountPrice = Double(self.chefDetail?.dining?.discountPrice ?? "0") ?? 0
                let actualPrice = Double(self.chefDetail?.dining?.pricePerson ?? "0") ?? 0
                
//                let finalPrice = (actualPrice ?? 0.0) - (discountPrice ?? 0.0)
                
//                chefDetail?.dining?.finalPrice = "\(finalPrice)"
                self.oldPrice.attributedText = setStroke(string: String(format: "AED %.0f", actualPrice))
                self.pricePersonLabel.text = String(format: "AED %.0f", discountPrice)
            }
            self.cuisineCollectionView.reloadData()
            let cHeight = cuisineCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.cuisineHeightConstraint.constant = cHeight
            
            self.allergensCollectionView.reloadData()
            let aHeight = allergensCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.allergensHeightConstraint.constant = aHeight
            
            self.chefCollectionView.reloadData()
            
            self.mainViewHeightConstraint.constant += cuisineHeightConstraint.constant + allergensHeightConstraint.constant + menuTableViewHeightConstraint.constant + logHeight! + gHeight! + exHeight!
            
            self.cancellationPolicyTableView.reloadData()
            self.cancellationPolicyTableHeightConstraint.constant = CGFloat((self.chefDetail?.dining?.cancels?.count ?? 0) * 30)
            self.cancellationPolicyViewHeightConstraint.constant += self.cancellationPolicyTableHeightConstraint.constant
            view.isHidden = false
        }
    }
    
    
    var menudata = [String]()
    var isFromDeepLink = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithSigleButton
        viewControllerTitle = pageTitle
        view.isHidden = true
        registerCells()
        getServerData(chefId: chefId!)
//        getServerData(chefId: chefId!)
        
        if isFromDeepLink {
            accepRejectView.isHidden = false
            bookNowView.isHidden = true
        } else {
            bookNowView.isHidden = false
            accepRejectView.isHidden = true
        }
    }
    private func registerCells() {
        
        chefCollectionView.register(UINib(nibName: NearByChefCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: NearByChefCollectionCell.description())
        chefCollectionView.delegate = self
        chefCollectionView.dataSource = self
        
        
        cuisineCollectionView.register(UINib(nibName: HomeChefDetailCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeChefDetailCollectionCell.description())
        cuisineCollectionView.delegate = self
        cuisineCollectionView.dataSource = self
        
        allergensCollectionView.register(UINib(nibName: HomeChefDetailCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeChefDetailCollectionCell.description())
        allergensCollectionView.dataSource = self
        allergensCollectionView.delegate = self
        
        
        
        cancellationPolicyTableView.register(UINib(nibName: CancellationPolicyTableCell.description(), bundle: nil), forCellReuseIdentifier: CancellationPolicyTableCell.description())
        menuTableView.register(UINib(nibName: MenuHomeChefTableCell.description(), bundle: nil), forCellReuseIdentifier: MenuHomeChefTableCell.description())
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    private func getServerData(chefId: Int) {
        HomeAPIManager.ChefDetailAPI(chefId: chefId) { result in
            switch result.status {
            case "Success":
                self.chefDetail = result
                break
            case "Fail":
                break
            default: break
            }
        }
    }
    
    @IBAction func bookNowTapped(_ sender: Any) {
        Coordinator.showBookingExperience(delegate: self, chef_detail: chefDetail)
    }
    @IBAction func scrollToTopBtnTapped(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    @IBAction func menuBtnTapped(_ sender: Any) {
        if let menu = self.chefDetail?.dining?.menuAttachment {
            if menu != "" {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShowMenuViewController") as! ShowMenuViewController
                
                controller.url = baseURL+menu
                self.present(controller, animated: true)
            }
        }
    }
}


extension HomeChefDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cuisineCollectionView:
            if let count = self.chefDetail?.dining?.cuisines?.count {
                return count
            }
            return 0
        case allergensCollectionView:
            if let count = self.chefDetail?.dining?.allergens?.count {
                return count
            }
            return 0
        case chefCollectionView:
            if let count = self.chefDetail?.dining?.gallery?.count {
                return count
            }
            return 0
//            return 8
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == chefCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByChefCollectionCell.description(), for: indexPath) as? NearByChefCollectionCell else {
                fatalError()
            }
            cell.gradientImage.isHidden = true
            cell.chefImage.ibcornerRadius = 5
            cell.chefImage.borderColor = .white
            cell.chefImage.borderWidth = 1
            
            if let gallery = self.chefDetail?.dining?.gallery?[indexPath.row] {
                let image = URL(string: "https://jarsite.com/splidu/public/uploads/"+gallery.image!)!
                cell.chefName.text = ""
                cell.chefCuisine.text = ""
                cell.chefImage.sd_setImage(with: image)
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeChefDetailCollectionCell.description(), for: indexPath) as? HomeChefDetailCollectionCell else {
                fatalError()
            }
            if collectionView == cuisineCollectionView {
                if let cuisines = self.chefDetail?.dining?.cuisines?[indexPath.row] {
                    cell.optionTitle.text = cuisines.title
                }
                
                cell.optionImage.isHidden = true
            } else {
                if let allergens = self.chefDetail?.dining?.allergens?[indexPath.row] {
                    cell.optionTitle.text = allergens.title
                    let image = URL(string: "https://jarsite.com/splidu/public/uploads/" + allergens.file!)
                    cell.optionImage.sd_setImage(with: image)
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let gallery = self.chefDetail?.dining?.gallery?[indexPath.row] {
            let url = URL(string: baseURL + (gallery.image ?? ""))
            self.mainChefImage.sd_setImage(with: url)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == chefCollectionView {
            return CGSize(width: 77, height: 83)
        } else {
            let size = self.cuisineCollectionView.frame.size
            return CGSize(width: size.width/3, height: 36)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == chefCollectionView {
            return 10.0
        } else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == chefCollectionView {
            return 10.0
        } else {
            return 0.0
        }
    }
}

extension HomeChefDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView {
            return menudata.count
        } else {
            if let count = self.chefDetail?.dining?.cancels?.count {
                return count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case menuTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHomeChefTableCell") as! MenuHomeChefTableCell
            
            cell.menuLabel.text = "" + menudata[indexPath.row]
            
            return cell
        case cancellationPolicyTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CancellationPolicyTableCell") as! CancellationPolicyTableCell
            
            if let cancel = self.chefDetail?.dining?.cancels?[indexPath.row] {
                cell.policyTime.text = "\(indexPath.row + 1). Cancel Before \(cancel.hours ?? 0) hours : "
                cell.policyTime.textColor = .white
                cell.refund.text = "Get \(cancel.refund ?? "")% Refund"
            }
            return cell
        default: return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
            case menuTableView: return 20
            case cancellationPolicyTableView: return 30
            default: return 0
        }
    }
}
