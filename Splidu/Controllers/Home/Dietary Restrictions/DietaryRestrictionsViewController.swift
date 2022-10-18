//
//  DietaryRestrictionsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit
//UD-888817BE14
class DietaryRestrictionsViewController: BaseViewController {

    @IBOutlet weak var allergensCollectionView: UICollectionView!
    @IBOutlet weak var dietaryCollectionView: UICollectionView!
    @IBOutlet weak var restrictionsTextField: UnderLineImageTextField!
    @IBOutlet weak var dislikeTextField: UnderLineImageTextField!
    
    @IBOutlet weak var isAcceptBtn: UIButton!
    var dietary: [BookingAttributesDetails]?
    var allergens: [BookingAttributesDetails]?
    
    var allDietary: [BookingAttributesDetails]?
    var userIndex: Int?
    var isAccept = ""
    
    let layout = TagFlowLayout()
    override func viewDidLoad() {
        super.viewDidLoad()

        type = .backWhite
        viewControllerTitle = "Dietary Restriction & Preferences"
        
        restrictionsTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDiet(notification:)), name: NSNotification.Name.init(rawValue: "UpdateDiet"), object: nil)
        
        if isAccept == "0" {
            isAcceptBtn.backgroundColor = .clear
            isAcceptBtn.isSelected = false
        } else {
            isAcceptBtn.isSelected = true
            isAcceptBtn.backgroundColor = Color.pinkPurple.color()
        }
        
        dietaryCollectionView.delegate = self
        dietaryCollectionView.dataSource = self
        
        layout.estimatedItemSize = CGSize(width: 40, height: 36)
        dietaryCollectionView.collectionViewLayout = layout
        
        allergensCollectionView.reloadData()
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        //        Coordinator.showOrderSuccessPopup(delegate: self)
        if self.isAccept == "0" {
            Utilities.showWarningAlert(message: "Please confirm Dietary and Allergens Restrictions.")
            return
        }
        let dictionary = [
            "allergens" : self.allergens,
            "dietaries": self.dietary,
            "isAccept" : self.isAccept,
            "dislikes" : self.dislikeTextField.text,
            "userIndex" : userIndex
        ] as [String:Any]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "addUpdateDietaries"), object: nil, userInfo: dictionary)
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: .ChangeIndexToOrders, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.isAccept = "1"
            sender.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.5)
        } else {
            self.isAccept = "0"
            sender.backgroundColor = .clear
        }
    }
}


extension DietaryRestrictionsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == restrictionsTextField {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DietaryPopupViewController") as! DietaryPopupViewController
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overFullScreen
            controller.dietary = allDietary
            self.present(controller, animated: true)
            return false
        }
        return true
    }
}


extension DietaryRestrictionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == allergensCollectionView {
            if let count = self.allergens?.count {
                return count
            }
            return 0
        } else {
            if let count = self.dietary?.count {
                return count
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == allergensCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DietaryAllergensCollectionCell", for: indexPath) as! DietaryAllergensCollectionCell
            if let aller = self.allergens?[indexPath.row] {
                cell.lbl.text = aller.title ?? ""
                let image = URL(string: "https://jarsite.com/splidu/public/uploads/" + aller.file!)
                if aller.isSelected {
                    cell.gradientBottom.isHidden = false
                    cell.contentView.borderColor = .clear //Color.underlineColor.color().withAlphaComponent(0.5)
                    cell.contentView.borderWidth = 0
                    cell.contentView.backgroundColor = Color.childViewColor.color()
                } else {
                    cell.gradientBottom.isHidden = true
                    cell.contentView.borderColor = .white
                    cell.contentView.borderWidth = 1
                    cell.contentView.backgroundColor = .clear
                    cell.contentView.ibcornerRadius = 5
                }
                cell.img.sd_setImage(with: image)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DietaryCell", for: indexPath) as! DietaryCollectionCell
            if let data = self.dietary?[indexPath.row] {
                if data.isSelected {
                    cell.dietaryLbl.text = data.title ?? ""
                    cell.contentView.borderWidth = 1
                    cell.contentView.borderColor = .white
                    cell.contentView.ibcornerRadius = 5
                    cell.xmarkBtn.tag = indexPath.row
                    cell.xmarkBtn.addTarget(self, action: #selector(removeDietary(sender:)), for: .touchUpInside)
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == allergensCollectionView {
            self.allergens![indexPath.row].isSelected = !self.allergens![indexPath.row].isSelected
            
            self.allergensCollectionView.reloadData()
        }
    }
    @objc private func removeDietary(sender: UIButton) {
//        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "AddDietary"), object: nil, userInfo: ["userIndex": userIndex, "id": self.dietary![sender.tag].id])
        self.dietary!.remove(at: sender.tag)
        self.dietaryCollectionView.reloadData()
    }
}

extension DietaryRestrictionsViewController {
    @objc fileprivate func updateDiet(notification: Notification) {
        if var diet = notification.userInfo?["dietary"] as? BookingAttributesDetails {
            if self.dietary == nil {
                diet.isSelected = true
                self.dietary = [diet]
            } else {
                if let count = self.dietary?.filter({ d in
                    d.id == diet.id
                }).count {
                    if count > 0 {
                        return
                    }
                }
                self.dietary?.append(diet)
            }
            dietaryCollectionView.reloadData()
        }
    }
}
