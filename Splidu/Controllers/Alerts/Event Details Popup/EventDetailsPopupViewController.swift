//
//  EventDetailsPopupViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class EventDetailsPopupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmedView: UIView!
    @IBOutlet weak var confirmTableView: UITableView!
    @IBOutlet weak var waitListView: UIView!
    @IBOutlet weak var waitlistTableView: UITableView!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var numberOfSeats: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var order_detail: OrderDetailModel?
    
    var isConfirmList: [AllGuest]?
    var isGuestList: [AllGuest]?
    
    let cancellationPolictyData = [
        [
            "key" : "1. Cancel Before 12 hours : ",
            "value" : "Get 75% Refund"
        ],
        [
            "key" : "2. Cancel Before 8 hours : ",
            "value" : "Get 50% Refund"
        ],
        [
            "key" : "3. Cancel Before 6 hours : ",
            "value" : "Get 35% Refund"
        ],
        [
            "key" : "4. Cancel Before 4 hours : ",
            "value" : "Get 25% Refund"
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupModel()
        view.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.15)
    }
    private func registerCells() {
        tableView.register(UINib(nibName: CancellationPolicyTableCell.description(), bundle: nil), forCellReuseIdentifier: CancellationPolicyTableCell.description())
//        tableView.dataSource = self
//        tableView.delegate = self
        
        confirmTableView.register(UINib(nibName: MemberListTableCell.description(), bundle: nil), forCellReuseIdentifier: MemberListTableCell.description())
//        confirmTableView.delegate = self
//        confirmTableView.dataSource = self
        
        waitlistTableView.register(UINib(nibName: MemberListTableCell.description(), bundle: nil), forCellReuseIdentifier: MemberListTableCell.description())
//        waitlistTableView.delegate = self
//        waitlistTableView.dataSource = self
    }
    private func setupModel() {
        self.orderNumberLbl.text = order_detail?.order?.confirmNumber ?? ""
        self.numberOfSeats.text = "\(Int((order_detail?.order?.waiting ?? 0) + Int(order_detail?.order?.confirmed ?? 0))) Seats"
        self.addressLbl.text = order_detail?.dining?.location ?? ""
        self.dateLbl.text = order_detail?.order?.ordermain?.diningDate ?? ""
        self.totalLbl.text = "AED \(order_detail?.order?.total ?? "")"
        self.isConfirmList = self.order_detail?.allGuests?.filter({ guest in
            guest.isWaiting == false
        })
        self.isGuestList = self.order_detail?.allGuests?.filter({ guest in
            guest.isWaiting == true
        })
        if let count = self.isConfirmList?.count {
            if count > 0 {
                self.confirmedView.isHidden = false
                self.confirmTableView.reloadData()
            }
        }
        if let count = self.isGuestList?.count {
            if count > 0 {
                self.waitListView.isHidden = false
                self.waitlistTableView.reloadData()
            }
        }
        self.tableView.reloadData()
//        self.
    }
    @IBAction func cancelAllBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            let deduction = 0
            let remaingTime = 0
            
            
            NotificationCenter.default.post(name: .ConfirmAllBookingCancel, object: nil)
        }
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
    }
}

extension EventDetailsPopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == confirmTableView {
            if let count = self.isConfirmList?.count {
                return count
            }
            return 0
        } else if tableView == waitlistTableView {
            if let count = self.isGuestList?.count {
                return count
            }
            return 0
        } else {
            if let count = self.order_detail?.dining?.cancels?.count {
                return count
            }
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == confirmTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableCell.description()) as! MemberListTableCell
            if let data = isConfirmList?[indexPath.row] {
                cell.personName.text = data.name ?? ""
                cell.personGender.text = data.gender ?? ""
                cell.buttonView.isHidden = false
                cell.cancelBtn.tag = indexPath.row
                cell.cancelBtn.addTarget(self, action: #selector(cancleSingleBooking(sender:)), for: .touchUpInside)
                cell.cancelBtn.accessibilityLabel = "Confirm"
            }
            return cell
        } else if tableView == waitlistTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableCell.description()) as! MemberListTableCell
            if let data = isGuestList?[indexPath.row] {
                cell.personName.text = data.name ?? ""
                cell.personGender.text = data.gender ?? ""
                cell.buttonView.isHidden = false
                cell.cancelBtn.tag = indexPath.row
                cell.cancelBtn.addTarget(self, action: #selector(cancleSingleBooking(sender:)), for: .touchUpInside)
                cell.cancelBtn.accessibilityLabel = "Wait"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CancellationPolicyTableCell") as! CancellationPolicyTableCell
            if let data = self.order_detail?.dining?.cancels?[indexPath.row] {
                cell.policyTime.text = "\(indexPath.row + 1). Cancel Before \(data.hours ?? 0) hours : "
                cell.policyTime.textColor = Color.customBlack.color()
                cell.refund.text = "Get \(data.refund ?? "")% Refund"
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != self.tableView {
            return 45
        }
        return 30
    }
    
    @objc private func cancleSingleBooking(sender: UIButton) {
        let tag = sender.tag
        let label = sender.accessibilityLabel
        var Id = 0
        if label == "Confirm" {
            if let id = self.isConfirmList?[tag].id {
                Id = id
            }
        } else {
            if let id = self.isGuestList?[tag].id {
                Id = id
            }
        }
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .ConfirmSingleBookingCancel, object: nil, userInfo: ["id" : Id])
        }
    }
}

