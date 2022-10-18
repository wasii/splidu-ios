//
//  AddNewLocationViewController.swift
//  Splidu
//
//  Created by Rafi on 03/09/2022.
//

import UIKit
protocol CallLocation {
    func callLocation()
}
class AddNewLocationViewController: UIViewController {

    @IBOutlet weak var buildingName: UITextField!
    @IBOutlet weak var floorNumber: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var addressType: [AddressType]?
    var locationData: LocationData?
    var delegate: CallLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressType = [
            AddressType(title: "Home", isSelected: false),
            AddressType(title: "Work", isSelected: false),
            AddressType(title: "Other", isSelected: false),
        ]
        
        if locationData != nil {
            self.buildingName.text = locationData?.buildingName ?? ""
            self.floorNumber.text = locationData?.floorNo ?? ""
            self.streetAddress.text = locationData?.streetAddress ?? ""
            self.country.text = locationData?.countryName ?? ""
            
            let selectedAddress: AddressType? = addressType?.filter({ type in
                type.title == locationData?.addressType ?? ""
            }).first
            
//            for address in addressType! {
//                if address.title == selectedAddress?.title ?? ""{
//
//                }
//            }
            addressType?.forEach({ type in
                if type.title == selectedAddress?.title {
                    type.isSelected = true
                }
            })
        }
        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func saveAddressBtn(_ sender: Any) {
        if buildingName.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if floorNumber.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if streetAddress.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        if country.text?.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        let parameters = [
            "building_name": buildingName.text!,
            "floor_no": floorNumber.text!,
            "street_address": streetAddress.text!,
            "country_name": country.text!,
            "address_type": addressType?.filter({ type in
                type.isSelected == true
            }).first?.title ?? ""
        ]
        var id: Int?
        if locationData != nil {
            id = locationData?.id ?? 0
        }
        ProfileAPIManager.AddNewLocation(id: id, paramaters: parameters) { model in
            switch model.status {
            case "Success":
                Utilities.showSuccessAlert(message: model.message ?? "") {
                    self.dismiss(animated: true) {
                        self.delegate?.callLocation()
                    }
                }
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "") {
                    self.dismiss(animated: true)
                }
                break
            default: break
            }
        }
    }
}

extension AddNewLocationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = addressType?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressTypeCollectionCell", for: indexPath) as! AddressTypeCollectionCell
        
        if let data = self.addressType?[indexPath.row] {
            if data.isSelected {
                cell.mainView.borderColor = .clear
                cell.mainView.borderWidth = 0
                cell.gradientBorder.isHidden = false
            } else {
                cell.mainView.borderColor = Color.underlineColor.color()
                cell.mainView.borderWidth = 1
                cell.gradientBorder.isHidden = true
            }
            cell.title.text = data.title
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.addressType!.forEach { ad in
            ad.isSelected = false
        }
        self.addressType![indexPath.row].isSelected = !self.addressType![indexPath.row].isSelected
        self.collectionView.reloadData()
    }
}
extension AddNewLocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.bounds.width / 3) - 10, height: 40.0)
    }
}


class AddressType {
    var title: String
    var isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}
