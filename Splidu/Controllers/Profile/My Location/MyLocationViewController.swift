//
//  MyLocationViewController.swift
//  Splidu
//
//  Created by Rafi on 03/09/2022.
//

import UIKit

class MyLocationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var location: [LocationData]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "My Location(s)"
        setupTableView()
        getAllLocations()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyLocationTableViewCell", bundle: nil), forCellReuseIdentifier: MyLocationTableViewCell.identifier)
    }
    private func getAllLocations() {
        ProfileAPIManager.GetAllLocations { locations in
            switch locations.status {
            case "Success":
                self.location = locations.data
                break
            case "Fail":
                break
            default: break
            }
        }
    }
    
    @IBAction func addNewLocationBtn(_ sender: Any) {
        Coordinator.AddNewLocation(delegate: self, callLocationDelegate: self, location: nil)
    }
}


extension MyLocationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        if let count = self.location?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyLocationTableViewCell.identifier) as! MyLocationTableViewCell
        if let location = self.location?[indexPath.row] {
            cell.addressTypeLabel.text = location.addressType ?? ""
            cell.addressLabel.text = "\(location.floorNo ?? "") - \(location.buildingName ?? "") - \(location.streetAddress ?? "") - \(location.countryName ?? "")"
            
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editAddress(sender:)), for: .touchUpInside)
            
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAddress(sender:)), for: .touchUpInside)
            
            if (location.status ?? 0) == 0 {
                cell.selectedAddressBtn.setImage(UIImage(named: "mylocation-unselected-radio"), for: .normal)
            } else {
                cell.selectedAddressBtn.setImage(UIImage(named: "mylocation-radio-selected"), for: .normal)
            }
            cell.selectedAddressBtn.tag = indexPath.row
            cell.selectedAddressBtn.addTarget(self, action: #selector(changeStatus(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc private func editAddress(sender: UIButton) {
        if let location = self.location?[sender.tag] {
            Coordinator.AddNewLocation(delegate: self, callLocationDelegate: self, location: location)
        }
    }
    @objc private func deleteAddress(sender: UIButton) {
        if let id = self.location?[sender.tag].id {
            ProfileAPIManager.DeleteLocation(id: "\(id)") { model in
                switch model.status {
                case "Success":
                    Utilities.showSuccessAlert(message: model.message ?? "") {
                        self.getAllLocations()
                    }
                    break
                case "Fail":
                    break
                default: break
                }
            }
        }
    }
    @objc private func changeStatus(sender: UIButton) {
        if let location = self.location?[sender.tag]{
            let status = (location.status ?? 0) == 0 ? 1 : 0
            let parameters = [
                "id" : location.id ?? 0,
                "status" : status
            ] as [String:Any]
            ProfileAPIManager.ChangeLocationStatus(paramaters: parameters) { model in
                switch model.status {
                case "Success":
                    Utilities.showSuccessAlert(message: model.message ?? "") {
                        self.getAllLocations()
                    }
                    break
                case "Fail":
                    break
                default: break
                }
            }
        }
    }
}


extension MyLocationViewController: CallLocation {
    func callLocation() {
        self.getAllLocations()
    }
}
