//
//  EventDetailsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class EventDetailsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmedTableView: UITableView!
    
    @IBOutlet weak var waitlistView: UIView!
    @IBOutlet weak var waitlistViewHeight: NSLayoutConstraint!
    @IBOutlet weak var waitlistTableView: UITableView!
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var numberOfSeatsLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cancelDateLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    @IBOutlet weak var experienceSummaryLbl: UILabel!
    @IBOutlet weak var guidelineLbl: UILabel!
    @IBOutlet weak var logisticsLbl: UILabel!
    
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    @IBOutlet weak var cuisinCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var allergensCollectionView: UICollectionView!
    @IBOutlet weak var allergensCollectionViewHeight: NSLayoutConstraint!
    
    var isConfirmList: [AllGuest]?
    var isGuestList: [AllGuest]?
    
    var menudata = [String]()
    var isWaiting: Int = 0
    var isConfirm: Int = 0
    
    var singleBookingId: Int = 0
    var completeBookingId: String = ""
    var order_detail: OrderDetailModel? {
        didSet {
            print("Order Dtail ID: \(orderId)")
            self.mainViewHeight.constant = 420
            scrollView.isHidden = false
            self.orderName.text = order_detail?.order?.confirmNumber ?? ""
            self.numberOfSeatsLbl.text = "\(Int((order_detail?.order?.waiting ?? 0) + Int(order_detail?.order?.confirmed ?? 0))) Seats"
            self.addressLbl.text = order_detail?.dining?.location ?? ""
            self.dateLbl.text = order_detail?.order?.ordermain?.diningDate ?? ""
            self.totalPriceLbl.text = "AED \(order_detail?.order?.total ?? "")"
            let font = UIFont(name: "Nunito-Regular", size: 15)!
            
            self.experienceSummaryLbl.text = self.order_detail?.dining?.experienceSummary ?? ""
            let exHeight = self.experienceSummaryLbl.text?.height(
                withConstrainedWidth: (self.experienceSummaryLbl.frame.size.width),
                font: font
            )
            self.logisticsLbl.text = self.order_detail?.dining?.logisticInformation ?? ""
            let logHeight = self.logisticsLbl.text?.height(
                withConstrainedWidth: (self.logisticsLbl.frame.size.width),
                font: font
            )
            self.guidelineLbl.text = "\(self.order_detail?.dining?.guidelinesInformation ?? "")"
            let gHeight = self.guidelineLbl.text?.height(
                withConstrainedWidth: (self.guidelineLbl.frame.size.width),
                font: font
            )
            let menu_data = (self.order_detail?.dining?.menuDescription ?? "").split(separator: "\n")
            self.menudata = menu_data.map { "\u{2022} \(String($0))" }
            self.tableView.reloadData()
            self.tableViewHeight.constant = CGFloat(menudata.count * 20)
            
            self.cuisineCollectionView.reloadData()
            let cHeight = cuisineCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.cuisinCollectionViewHeight.constant = cHeight
            
            self.allergensCollectionView.reloadData()
            let aHeight = allergensCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.allergensCollectionViewHeight.constant = aHeight
            
            self.isConfirmList = self.order_detail?.allGuests?.filter({ guest in
                guest.isWaiting == false
            })
            self.isGuestList = self.order_detail?.allGuests?.filter({ guest in
                guest.isWaiting == true
            })
            if let count = self.isConfirmList?.count {
                if count > 0 {
                    self.confirmViewHeight.constant = 0
                    self.confirmView.isHidden = false
                    self.confirmedTableView.reloadData()
                    self.confirmViewHeight.constant += CGFloat(45 * count)  + 29.5
                    self.mainViewHeight.constant += self.confirmViewHeight.constant
                }
            }
            if let count = self.isGuestList?.count {
                if count > 0 {
                    self.waitlistViewHeight.constant = 0
                    self.waitlistView.isHidden = false
                    self.waitlistTableView.reloadData()
                    self.waitlistViewHeight.constant += CGFloat(45 * count) + 29.5
                    self.mainViewHeight.constant += self.waitlistViewHeight.constant
                }
            }
//            
            self.mainViewHeight.constant += cuisinCollectionViewHeight.constant + allergensCollectionViewHeight.constant + tableViewHeight.constant + logHeight! + gHeight! + exHeight!
        }
    }
    var orderId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "Event Details"
        registerCells()
        registerNotifications()
        
        scrollView.isHidden = true
        getOrderDetails()
    }
    private func getOrderDetails() {
        OrdersAPIManager.GetOrderDetail(orderId: orderId) { orderDetail in
            switch orderDetail.status {
                case "Success":
                    self.order_detail = orderDetail
                    break
                case "Fail":
                    break
                default: break
            }
        }
    }
    private func registerNotifications() {
        //All Booking Cancelled
        NotificationCenter.default.addObserver(self, selector: #selector(showAllBookingCancelPopup), name: .ConfirmAllBookingCancel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAllBookingCancelledSuccessPopup), name: .ShowAllBookingCancelSuccessPopup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToBack), name: .ExploreAllBookingCancelled, object: nil)
        
        //Single Booking Cancelled
        NotificationCenter.default.addObserver(self, selector: #selector(showSingleBookingCancelPopup), name: .ConfirmSingleBookingCancel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSingleBookingCancelledSuccessPopup), name: .ShowSingleBookingCancelSuccessPopup, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshEventDetails), name: .RefreshEventDetails, object: nil)
    }
    private func registerCells() {
        
        cuisineCollectionView.register(UINib(nibName: HomeChefDetailCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeChefDetailCollectionCell.description())
        cuisineCollectionView.delegate = self
        cuisineCollectionView.dataSource = self
        
        allergensCollectionView.register(UINib(nibName: HomeChefDetailCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeChefDetailCollectionCell.description())
        allergensCollectionView.dataSource = self
        allergensCollectionView.delegate = self
        
        tableView.register(UINib(nibName: MenuHomeChefTableCell.description(), bundle: nil), forCellReuseIdentifier: MenuHomeChefTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        
        confirmedTableView.register(UINib(nibName: MemberListTableCell.description(), bundle: nil), forCellReuseIdentifier: MemberListTableCell.description())
        confirmedTableView.delegate = self
        confirmedTableView.dataSource = self
        
        waitlistTableView.register(UINib(nibName: MemberListTableCell.description(), bundle: nil), forCellReuseIdentifier: MemberListTableCell.description())
        waitlistTableView.delegate = self
        waitlistTableView.dataSource = self
        
    }
    @IBAction func menuBtnTapped(_ sender: Any) {
    }
    @IBAction func cancelBookingTapped(_ sender: Any) {
        Coordinator.showEventDetailsPopup(delegate: self, order_detail: order_detail)
    }
    
    //AllBooking Cancelled Popups
    @objc private func showAllBookingCancelPopup(){
        let bookingDateString = self.order_detail?.order?.ordermain?.diningDate ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let currentDateString = dateFormatter.string(from: Date())
        
        let currentDate = dateFormatter.date(from: currentDateString) ?? Date()
        let bookingDate = dateFormatter.date(from: bookingDateString) ?? Date()
        
        let remaining = (bookingDate - currentDate).asHours()
        var deduction = "0"
        if remaining < 0 {
            Utilities.showWarningAlert(message: "Booking already completed.")
        } else {
            
            if let cancelPolicy = self.order_detail?.dining?.cancels {
                for (i, c) in cancelPolicy.enumerated() {
                    if Double(c.hours ?? 0) < remaining {
                        deduction = c.refund ?? ""
                        break
                    }
                }
            }
        }
        Coordinator.showConfirmAllBookingCancel(delegate: self, duduction: deduction)
    }
    @objc private func showAllBookingCancelledSuccessPopup(){
        //Entire Boooking will cancel here.
        
        
        let params = [
            "confirm_number" : "\(self.order_detail?.order?.confirmNumber ?? "")",
            "is_complete" : 1,
            "id": 0
        ] as [String:Any]
        OrdersAPIManager.CancelSingleBooking(params: params) { model in
            switch model.status {
            case "Success":
                Coordinator.showAllBookingCancelledSuccessPopup(delegate: self, message: model.message ?? "")
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "")
                break
            default: break
            }
        }
    }
    
    //Single Booking Cancelled Popup
    @objc private func showSingleBookingCancelPopup(notification: Notification) {
        singleBookingId = notification.userInfo?["id"] as? Int ?? 0
        Coordinator.showConfirmSingleBookingCancel(delegate: self)
    }
    @objc private func showSingleBookingCancelledSuccessPopup() {
        //MARK: API Will Hit here
        let params = [
            "confirm_number" : "\(self.order_detail?.order?.confirmNumber ?? "")",
            "is_complete" : 0,
            "id": self.singleBookingId
        ] as [String:Any]
        OrdersAPIManager.CancelSingleBooking(params: params) { model in
            switch model.status {
            case "Success":
                Coordinator.showSingleBookingCancelledSuccessPopup(delegate: self)
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "")
                break
            default: break
            }
        }
    }
    @objc private func refreshEventDetails() {
        getOrderDetails()
    }
    
    @objc private func navigateToBack() {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .ChangeIndexToHome, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == confirmedTableView {
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
            return menudata.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == confirmedTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableCell.description()) as! MemberListTableCell
            if let data = isConfirmList?[indexPath.row] {
                cell.personName.text = data.name ?? "Splidu Dummy Name"
                cell.personGender.text = data.gender ?? "( male - 25 )"
                if self.isConfirmList!.count - 1  == indexPath.row {
                    cell.seperator.isHidden = true
                } else {
                    cell.seperator.isHidden = false
                }
                if data.orderStatus == "CANCELLED" {
                    cell.statusLabel.isHidden = false
                    cell.statusLabel.text = "Cancelled on \(data.date ?? "")"
                } else {
                    if (data.isWaiting ?? false) {
                        cell.statusLabel.isHidden = true
                        cell.statusLabel.text = ""
                    } else {
                        cell.statusLabel.isHidden = false
                        cell.statusLabel.text = "Confirm on: \(data.date ?? "")"
                    }
                }
            }
            return cell
        } else if tableView == waitlistTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableCell.description()) as! MemberListTableCell
            if let data = isGuestList?[indexPath.row] {
                cell.personName.text = data.name ?? ""
                cell.personGender.text = data.gender ?? ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHomeChefTableCell") as! MenuHomeChefTableCell
            
            cell.menuLabel.text = "" + menudata[indexPath.row]
            cell.menuLabel.textColor = .black
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != self.tableView {
            return 45
        }
        return 20
    }
}


extension EventDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cuisineCollectionView:
            if let count = self.order_detail?.dining?.cuisines?.count {
                return count
            }
            return 0
        case allergensCollectionView:
            if let count = self.order_detail?.dining?.allergens?.count {
                return count
            }
            return 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeChefDetailCollectionCell.description(), for: indexPath) as? HomeChefDetailCollectionCell else {
            fatalError()
        }
        cell.backView.backgroundColor = .white
        cell.optionTitle.textColor = Color.customBlack.color()
        if collectionView == cuisineCollectionView {
            if let cuisines = self.order_detail?.dining?.cuisines?[indexPath.row] {
                cell.optionTitle.text = cuisines.title
            }
            
            cell.optionImage.isHidden = true
        } else {
            if let allergens = self.order_detail?.dining?.allergens?[indexPath.row] {
                cell.optionTitle.text = allergens.title
                let image = URL(string: "https://jarsite.com/splidu/public/uploads/" + allergens.file!)
                cell.optionImage.sd_setImage(with: image)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.cuisineCollectionView.frame.size
        return CGSize(width: size.width/3, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
