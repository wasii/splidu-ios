//
//  AddProfileDetailPopupViewController.swift
//  Splidu
//
//  Created by Wasiq Saleem on 22/09/2022.
//

import UIKit
protocol UpdateProfileDelegate {
    func updateAllergens(allergens: BookingAttributesDetails)
    func updateDietaries(dietaries: BookingAttributesDetails)
    func updateDislikes(dislikes: BookingAttributesDetails)
    func updateInterest(interest: BookingAttributesDetails)
}
class AddProfileDetailPopupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var interest, allergens, dietaries, dislikes: [BookingAttributesDetails]?
    var updateProfileDelegate: UpdateProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.view {
                dismiss(animated: true)
            }
        }
        
    }
}

extension AddProfileDetailPopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.interest?.count {
            return count
        }
        if let count = self.allergens?.count {
            return count
        }
        if let count = self.dietaries?.count {
            return count
        }
        if let count = self.dislikes?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateProfileDetailPopupTableCell") as! UpdateProfileDetailPopupTableCell
        if let data = self.interest {
            cell.titleLbl.text = data[indexPath.row].title
        }
        if let data = self.allergens {
            cell.titleLbl.text = data[indexPath.row].title
        }
        if let data = self.dietaries {
            cell.titleLbl.text = data[indexPath.row].title
        }
        if let data = self.interest {
            cell.titleLbl.text = data[indexPath.row].title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let allergens = self.allergens {
            self.allergens![indexPath.row].isSelected = !self.allergens![indexPath.row].isSelected
            self.dismiss(animated: true) {
                self.updateProfileDelegate?.updateAllergens(allergens: allergens[indexPath.row])
            }
        }
        if let dietaries = self.dietaries {
            self.dietaries![indexPath.row].isSelected = !self.dietaries![indexPath.row].isSelected
            self.dismiss(animated: true) {
                self.updateProfileDelegate?.updateDietaries(dietaries: dietaries[indexPath.row])
            }
        }
        if let dislikes = self.dislikes {
            self.dislikes![indexPath.row].isSelected = !self.dislikes![indexPath.row].isSelected
            self.dismiss(animated: true) {
                self.updateProfileDelegate?.updateDislikes(dislikes: dislikes[indexPath.row])
            }
        }
        if let interest = self.interest {
            self.interest![indexPath.row].isSelected = !self.interest![indexPath.row].isSelected
            self.dismiss(animated: true) {
                self.updateProfileDelegate?.updateInterest(interest: interest[indexPath.row])
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
