//
//  OrdersTableCell.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class OrdersTableCell: UITableViewCell {

    override class func description() -> String {
        return "OrdersTableCell"
    }
    @IBOutlet weak var viewLoacationView: UIView!
    @IBOutlet weak var viewLocationBtn: UIButton!
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var numberOfPeoples: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var waitingListBtn: UIButton!
    
    let data = ["person0", "person1", "person2", "person3", "person4", "person5", "person6", "person7", "person8"]
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: PeoplesCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: PeoplesCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}


extension OrdersTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeoplesCollectionCell.description(), for: indexPath) as! PeoplesCollectionCell
        cell.userImage.image = UIImage(named: data[indexPath.row])!
        return cell
    }
}


extension OrdersTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - 5
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -30.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
