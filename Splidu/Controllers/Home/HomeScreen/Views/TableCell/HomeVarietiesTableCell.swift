//
//  HomeVarietiesTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit

class HomeVarietiesTableCell: UITableViewCell {
    override class func description() -> String {
        return "HomeVarietiesTableCell"
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var title: String?
    var imageName: String?
    var diningData: [Datum]?
    var featuredChefData: [FeaturedChef]?
    var baseUrl: String?
    var isChef = false
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: HomeListingCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeListingCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}

extension HomeVarietiesTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
        if let count = self.diningData?.count {
            return count
        }
        if let count = self.featuredChefData?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeListingCollectionCell.description(), for: indexPath) as? HomeListingCollectionCell else {
            fatalError()
        }
        if let dining_data = self.diningData {
            let data = dining_data[indexPath.row]
            if let image = data.image {
                let imageUrl = URL(string: self.baseUrl!+image)
                cell.bgImage.sd_setImage(with: imageUrl)
                cell.bgImage.contentMode = .scaleAspectFill
            } else {
                cell.bgImage.image = UIImage(named: "homeIcon")
                cell.bgImage.contentMode = .scaleAspectFit
            }
            cell.title.text = data.title ?? ""
            cell.descriptionLabel.text = data.slug ?? ""
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(addToFav(sender:)), for: .touchUpInside)
            cell.favBtn.accessibilityLabel = "Dining"
            
            if (data.favorite_count ?? 0) == 0 {
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            cell.favBtn.tintColor = .white
        }
        if let featured_chef = self.featuredChefData {
            let chef = featured_chef[indexPath.row]
            if let image = chef.userImage {
                let imageUrl = URL(string: self.baseUrl!+image)
                cell.bgImage.sd_setImage(with: imageUrl)
                cell.bgImage.contentMode = .scaleAspectFill
            } else {
                cell.bgImage.image = UIImage(named: "homeIcon")
                cell.bgImage.contentMode = .scaleAspectFit
            }
            cell.title.text = chef.name ?? ""
            cell.descriptionLabel.text = chef.lastName ?? ""
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(addToFav(sender:)), for: .touchUpInside)
            cell.favBtn.accessibilityLabel = "Chef"
            if (chef.favorite_count ?? 0) == 0 {
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            cell.favBtn.tintColor = .white
        }
        
        
        return cell
    }
    
    @objc private func addToFav(sender: UIButton) {
        Utilities.discardGuestUserSession()
        var parameters = [String:Any]()
        if sender.accessibilityLabel == "Chef" {
            let data = self.featuredChefData![sender.tag]
            parameters = [
                "chef" : data.id ?? 0,
                "type" : "chef"
            ] as [String:Any]
            
        } else {
            let data = self.diningData![sender.tag]
            parameters = [
                "dining" : data.id ?? 0,
                "type" : "dining"
            ] as [String: Any]
        }
        FavouritesAPIManager.AddFavourites(paramater: parameters) { model in
            switch model.status {
            case "Success":
                Utilities.showSuccessAlert(message: model.message ?? "")
                NotificationCenter.default.post(name: .FetchNewFavourites, object: nil)
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "")
                break
            default: break
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width - 10, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
