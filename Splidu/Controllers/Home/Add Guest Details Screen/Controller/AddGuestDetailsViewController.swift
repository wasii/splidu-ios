//
//  AddGuestDetailsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import UIKit
//UD-998D3A0F57
class AddGuestDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var numberOfSeats = "2"
    var rowCount: Int?
    var genders: [GenderOptions]?
    var addGuest: [AddGuest]?
    var bookingAttributes: BookingAttributesModel?
    var allergens: [BookingAttributesDetails]?
    var diet: [BookingAttributesDetails]?
    
    var order_number = ""
    var confirmBooking = false
    
    var chefId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWhite
        viewControllerTitle = "Add Details"
        
        registerCells()
        setupModel()
        rowCount = 1
        addGuest = [
            AddGuest(isJoining: true, name: nil, age: nil, gender: nil, allergens: nil, dietaries: nil, isAccept: "0",dislikes: nil)
        ]
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHome), name: .CompleteOrder, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBookingAttributes(notification:)), name: NSNotification.Name.init(rawValue: "AddDietary"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addUpdateDietaries(notification:)), name: NSNotification.Name.init(rawValue: "addUpdateDietaries"), object: nil)
        
        
        print("CHEF ID: \(chefId)")
    }
    
    private func setupModel() {
        HomeAPIManager.GetBookingAttributes { result in
            switch result.status {
            case "Success":
                self.bookingAttributes = result
                self.allergens = result.allergens
                self.diet = result.dietaryRestrictions
            case "Fail":
                break
            default: break
            }
        }
    }
    
    @objc private func addUpdateDietaries(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let userInfo = notification.userInfo as? [String:Any] {
                if let userIndex = userInfo["userIndex"] as? Int {
                    let a = userInfo["allergens"] as? [BookingAttributesDetails]
                    let d = userInfo["dietaries"] as? [BookingAttributesDetails]
                    let isAccept = userInfo["isAccept"] as? String
                    let dislikes = userInfo["dislikes"] as? String ?? ""
                    self.addGuest![userIndex].allergens = a
                    self.addGuest![userIndex].dietaries = d
                    self.addGuest![userIndex].isAccept  = isAccept ?? "0"
                    self.addGuest![userIndex].dislikes = dislikes
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func registerCells() {
        tableView.register(UINib(nibName: AddGuestDetailTableCell.description(), bundle: nil), forCellReuseIdentifier: AddGuestDetailTableCell.description())
        tableView.register(UINib(nibName: AddGuestButtonTableCell.description(), bundle: nil), forCellReuseIdentifier: AddGuestButtonTableCell.description())
        tableView.register(UINib(nibName: AddGuestConfirmationTableCell.description(), bundle: nil), forCellReuseIdentifier: AddGuestConfirmationTableCell.description())
        tableView.register(UINib(nibName: AddGuestCompleteBookingTableCell.description(), bundle: nil), forCellReuseIdentifier: AddGuestCompleteBookingTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        genders = [
            GenderOptions(isMaleSelected: false, isFemaleSelected: false, isNotToDisclose: false),
        ]
        tableView.reloadData()
    }
    
    @objc func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: .ChangeIndexToOrders, object: nil)
    }
}


extension AddGuestDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = self.addGuest?.count {
                return count
            }
            return 0
        case 1, 2, 3: return 1
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestDetailTableCell.description()) as! AddGuestDetailTableCell
//            let genderdata = self.genders![indexPath.row]
            
            
            cell.femaleGradient.isHidden = true
            cell.maleGradient.isHidden = true
            cell.dicloseGradient.isHidden = true
            
            cell.femaleView.borderColor = .white
            cell.maleView.borderColor = .white
            cell.discloseView.borderColor = .white
            
            cell.femaleBtn.tag = indexPath.row
            cell.maleBtn.tag = indexPath.row
            cell.discloseBtn.tag = indexPath.row
            
            cell.femaleBtn.addTarget(self, action: #selector(detectGenderTapped(sender:)), for: .touchUpInside)
            cell.maleBtn.addTarget(self, action: #selector(detectGenderTapped(sender:)), for: .touchUpInside)
            cell.discloseBtn.addTarget(self, action: #selector(detectGenderTapped(sender:)), for: .touchUpInside)
        
            
            cell.personOneLabel.text = "Person \(indexPath.row + 1)"
            if let addGuestData = self.addGuest?[indexPath.row] {
                cell.willJoinBtn.tag = indexPath.row
                cell.willJoinBtn.addTarget(self, action: #selector(addJoining(sender:)), for: .touchUpInside)
                if addGuestData.isJoining == nil {
                    cell.willJoinBtn.isHidden = false
                } else {
                    if addGuestData.isJoining ?? false {
                        cell.willJoinBtn.backgroundColor = Color.darkPurple.color()
                    } else {
                        cell.willJoinBtn.backgroundColor = .clear
                    }
                }
                
                cell.fullNameTextField.delegate = self
                cell.fullNameTextField.accessibilityLabel = "firstname"
                cell.fullNameTextField.tag = indexPath.row
                
                cell.ageTextField.delegate = self
                cell.ageTextField.accessibilityLabel = "age"
                cell.ageTextField.tag = indexPath.row
                
                
                if addGuestData.name == nil {
                    cell.fullNameTextField.text = ""
                } else {
                    cell.fullNameTextField.text = addGuestData.name!
                }
                
                if addGuestData.age == nil {
                    cell.ageTextField.text = ""
                } else {
                    cell.ageTextField.text = addGuestData.age!
                }
                
                if addGuestData.gender == "Male" {
                    cell.maleGradient.isHidden = false
                    cell.maleView.borderColor = .clear
                }
                if addGuestData.gender == "Female" {
                    cell.femaleGradient.isHidden = false
                    cell.femaleView.borderColor = .clear
                }
                if addGuestData.gender == "Prefer Not to Disclose" {
                    cell.dicloseGradient.isHidden = false
                    cell.discloseView.borderColor = .clear
                }
                var dietaryCount = 0
                var allergenCount = 0
                
                if let dietCount = addGuestData.dietaries?.filter({ detail in
                    detail.isSelected == true
                }).count {
                    if dietCount > 0 {
                        dietaryCount = dietCount
                    }
                }
                if let allerCount = addGuestData.allergens?.filter({ detail in
                    detail.isSelected == true
                }).count {
                    if allerCount > 0 {
                        allergenCount = allerCount
                    }
                }
                
                if dietaryCount != 0 || allergenCount != 0 || addGuestData.isAccept != "0"  {
                    cell.addEditBackView.isHidden = true
                    cell.addEditLabel.tag = indexPath.row
                    cell.addEditLabel.setTitle("Edit Dietary Restrictions", for: .normal)
                    cell.addEditLabel.addTarget(self, action: #selector(showDietaryScreen(sender:)), for: .touchUpInside)
                } else {
                    cell.addEditBackView.isHidden = false
                    cell.addEditLabel.setTitle("Add Dietary Restrictions", for: .normal)
                    cell.addEditLabel.tag = indexPath.row
                    cell.addEditLabel.addTarget(self, action: #selector(showDietaryScreen(sender:)), for: .touchUpInside)
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestButtonTableCell.description()) as! AddGuestButtonTableCell
            cell.didTapOnInviteGuest = {
                ShareSheet.openShareSheet(rootController: self, chefID: "1")
            }
            if Int(numberOfSeats) == self.addGuest!.count {
                cell.addGuestBtn.alpha = 0.4
                cell.addGuestBtn.isUserInteractionEnabled = false
            } else {
                cell.addGuestBtn.alpha = 1.0
                cell.addGuestBtn.isUserInteractionEnabled = true
                cell.addGuestBtn.addTarget(self, action: #selector(addNewGuestBox), for: .touchUpInside)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestConfirmationTableCell.description()) as! AddGuestConfirmationTableCell
            if self.confirmBooking {
                cell.confirmBtn.backgroundColor = Color.darkPurple.color().withAlphaComponent(0.5)
            } else {
                cell.confirmBtn.backgroundColor = .clear//Color.underlineColor.color().withAlphaComponent(0.5)
            }
            cell.confirmBtn.addTarget(self, action: #selector(confirmBookings(sender:)), for: .touchUpInside)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestCompleteBookingTableCell.description()) as! AddGuestCompleteBookingTableCell
            cell.completeBookingBtn.addTarget(self, action: #selector(completeBooking), for: .touchUpInside)
            return cell
        default: return UITableViewCell()
        }
    }
    
    @objc private func confirmBookings(sender:UIButton) {
        if self.confirmBooking {
            self.confirmBooking = false
        } else {
            self.confirmBooking = true
        }
        self.tableView.reloadData()
    }
    
    @objc private func addJoining(sender:UIButton) {
        if self.addGuest![sender.tag].isJoining == nil {
            self.addGuest![sender.tag].isJoining = true
        } else {
            self.addGuest![sender.tag].isJoining = !self.addGuest![sender.tag].isJoining!
        }
        
        self.tableView.reloadData()
    }
    
    @objc func addNewGuestBox() {
        self.addGuest?.append(AddGuest(isJoining: false, name: nil, age: nil, gender: nil, allergens: nil, dietaries: nil, isAccept: "0", dislikes: nil))
        self.tableView.reloadData()
    }
    
    @objc func completeBooking() {
        if !self.confirmBooking {
            Utilities.showWarningAlert(message: "Please check Dietaries and Allergens policy.")
            return
        }
        var params = [String:Any]()
        var name = ""
        var age = ""
        var gender = ""
        var joining = ""
        var is_waiting = ""
        var dietaries = ""
        var allergens = ""
        var is_accept = ""
        var dislike_comment = ""
        
        for (i, guest) in self.addGuest!.enumerated() {
            if guest.name == nil {
                self.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: false)
                return
            }
            if guest.age == nil {
                self.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: false)
                return
            }
            if guest.gender == nil {
                self.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: false)
                return
            }
            
            if let dietary = self.addGuest?[i].dietaries?.filter({ diet in
                diet.isSelected == true
            }) {
                for (j, d) in dietary.enumerated() {
                    if j == dietary.endIndex - 1 {
                        dietaries += "\(d.id ?? 0) | "
                    } else {
                        dietaries += "\(d.id ?? 0),"
                    }
                }
            } else {
                if i == addGuest!.endIndex - 1 {
                    dietaries += "0"
                } else {
                    dietaries += "0 | "
                }
            }
            
            if let allergen = self.addGuest?[i].allergens?.filter({ aller in
                aller.isSelected == true
            }) {
                for (j, a) in allergen.enumerated() {
                    if j == allergen.endIndex - 1 {
                        allergens += "\(a.id ?? 0) | "
                    } else {
                        allergens += "\(a.id ?? 0),"
                    }
                }
            } else {
                if i == addGuest!.endIndex - 1 {
                    allergens += "0"
                } else {
                    allergens += "0 | "
                }
            }
            
            if i == addGuest!.endIndex - 1 {
                name += "\(guest.name!)"
                age += "\(guest.age!)"
                gender += "\(guest.gender!)"
                joining += "1"
                is_waiting += "0"
                is_accept += "\(guest.isAccept ?? "0")"
                dislike_comment += "\(guest.dislikes ?? "")"
            } else {
                name += "\(guest.name!) | "
                age += "\(guest.age!) | "
                gender += "\(guest.gender!) | "
                joining += "1 | "
                is_waiting += "0 | "
                is_accept += "\(guest.isAccept ?? "0") | "
                dislike_comment += "\(guest.dislikes ?? "") | "
            }
            
        }
        params = [
            "name" : name,
            "age" : age,
            "gender" : gender,
            "joining" : joining,
            "is_waiting" : is_waiting,
            "dietaries" : String(dietaries.dropLast(3)),
            "allergens" : String(allergens.dropLast(3)),
            "is_accept" : is_accept,
            "dislike_comment": dislike_comment
        ]
        print(params)
        
        HomeAPIManager.AddGuestDetails(parameters: params, orderId: order_number) { result in
            switch result.status {
            case "Success" :
                print(result.message)
                Coordinator.showOrderSuccessPopup(delegate: self)
                break
            case "Fail":
                Utilities.showWarningAlert(message: result.message ?? "")
                break
            default : break
            }
        }
    }
    
    @objc func detectGenderTapped(sender: UIButton) {
        self.addGuest![sender.tag].gender = sender.titleLabel?.text ?? ""
        self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 300
        case 1: return 50
        case 2: return 105
        case 3: return 200
        default: return 0
        }
    }
    
    @objc private func showDietaryScreen(sender:UIButton) {
        if self.addGuest![sender.tag].allergens == nil && self.addGuest![sender.tag].dietaries == nil {
            Coordinator.showDietaryScreen(viewController: self,
                                          allDiet: bookingAttributes?.dietaryRestrictions,
                                          diet: addGuest![sender.tag].dietaries,
                                          allergens: bookingAttributes?.allergens,
                                          userIndex: sender.tag,
                                          is_accept: addGuest![sender.tag].isAccept)
        } else {
            Coordinator.showDietaryScreen(viewController: self,
                                          allDiet: bookingAttributes?.dietaryRestrictions,
                                          diet: addGuest![sender.tag].dietaries,
                                          allergens: addGuest![sender.tag].allergens,
                                          userIndex: sender.tag,
                                          is_accept: addGuest![sender.tag].isAccept)
        }
        
    }
}

extension AddGuestDetailsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let label = textField.accessibilityLabel
        if label == "firstname" {
            self.addGuest![textField.tag].name = textField.text ?? ""
        } else {
            self.addGuest![textField.tag].age = textField.text ?? ""
        }
    }
}

class AddGuest {
    var isJoining: Bool?
    var name: String?
    var age: String?
    var gender: String?
    var allergens, dietaries: [BookingAttributesDetails]?
    var isAccept: String?
    var dislikes: String?
    
    init(isJoining: Bool?, name: String?, age: String?, gender: String?, allergens: [BookingAttributesDetails]?, dietaries: [BookingAttributesDetails]?, isAccept: String, dislikes: String?) {
        self.isJoining = isJoining
        self.name = name
        self.age = age
        self.gender = gender
        self.allergens = allergens
        self.dietaries = dietaries
        self.isAccept = isAccept
        self.dislikes = dislikes
    }
}


extension AddGuestDetailsViewController {
    @objc fileprivate func updateBookingAttributes(notification: Notification) {
        //adding diet Element
        if let addDiet = notification.userInfo?["addDietary"] as? BookingAttributesDetails,
           let userIndex = notification.userInfo?["userIndex"] as? Int {
            if self.addGuest![userIndex].dietaries == nil {
                self.addGuest![userIndex].dietaries = [addDiet]
            } else {
                self.addGuest![userIndex].dietaries?.append(addDiet)
            }
            self.tableView.reloadData()
        }
        //Removing diet Element
        if let dietId = notification.userInfo?["id"] as? Int,
           let userIndex = notification.userInfo?["userIndex"] as? Int {
            self.addGuest![userIndex].dietaries!.removeAll { $0.id == dietId }
            if self.addGuest![userIndex].dietaries!.count == 0 {
                self.addGuest![userIndex].dietaries = nil
            }
            self.tableView.reloadData()
        }
        
        //adding and updating allergen element
        if let alle = notification.userInfo?["addUpdateAllergens"] as? BookingAttributesDetails,
           let userIndex = notification.userInfo?["userIndex"] as? Int {
            if self.addGuest![userIndex].allergens == nil {
                self.addGuest![userIndex].allergens = allergens
            }
            if let index = self.addGuest![userIndex].allergens!.firstIndex(where: {$0.id == alle.id}) {
                self.addGuest![userIndex].allergens![index] = alle
            }
            
            self.tableView.reloadData()
        }
        
        if let isaccept = notification.userInfo?["isaccept"] as? String,
           let userIndex = notification.userInfo?["userIndex"] as? Int {
            self.addGuest![userIndex].isAccept = isaccept
            self.tableView.reloadData()
        }
    }
}
