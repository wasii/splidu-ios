//
//  DietaryPopupViewController.swift
//  Splidu
//
//  Created by Wasiq Saleem on 21/09/2022.
//

import UIKit

class DietaryPopupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dietary: [BookingAttributesDetails]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.customBlack.color().withAlphaComponent(0.4)
    }
}
extension DietaryPopupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.dietary?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryPopupCell") as! DietaryPopupCell
        if let data = self.dietary?[indexPath.row] {
            cell.titleName.text = data.title ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dietary![indexPath.row].isSelected = !self.dietary![indexPath.row].isSelected
        self.dismiss(animated: true) {
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "UpdateDiet"), object: nil, userInfo: ["dietary": self.dietary![indexPath.row]])
        }
    }
}
