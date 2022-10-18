//
//  BookYourExperienceViewController.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit
import Stripe

protocol UpdateWaitingList {
    func updateWaitingList(index: Int)
}

class BookYourExperienceViewController: BaseViewController {

    @IBOutlet weak var waitingListView: UIView!
    @IBOutlet weak var waitingListLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var totalSeatsLbl: UILabel!
    @IBOutlet weak var guestBookingLbl: UILabel!
    @IBOutlet weak var addGuestWaitlistBtn: UIButton!
    @IBOutlet weak var monthSelectionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var waitingListHeight: NSLayoutConstraint!
    @IBOutlet weak var waitingListCollectionView: UICollectionView!
    @IBOutlet weak var numberOfSeatCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var numberOfSeatHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    @IBOutlet weak var bookingSlotCollectionView: UICollectionView!
    
    @IBOutlet weak var commentsForChef: UnderLineImageTextField!
    
    @IBOutlet weak var promoCode: UnderLineImageTextField!
    
    @IBOutlet weak var payUsingWallet: UnderLineImageTextField!
    
    @IBOutlet var radioButtons: [UIButton]!
    @IBOutlet weak var partiallyBtn: UIButton!
    
    var chef_detail: HomeChefDetailModel?
    var billDetail: [BillDetail]?
    var numberOfSeat = ""
    
    var partialPayment = 0
    var secretkey = ""
    var transID = ""
    var paymentSheet: PaymentSheet?
    var isPayWithCard: Bool = true
    var stripeDictAsParams: [String: Any] = [:]
    
    var dateWise: GetSeatsFromDates? {
        didSet {
            getTimes()
        }
    }
    
    var isFirstLoad = true
    var currentMonthName: String = ""
    var timeSlots : [AvailableTimeSlots]?
    var calendarData: [HomeChefDetailDates]?
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Nunito-SemiBold", size: 14),
        .foregroundColor: Color.customPink.color(),
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    var bookSeats = [SelectSeats]()
    var guestBookingSeats = 0
    var paybyWallet: Double = 0.0
    var subTotal: Double = 0.0
    var totalAmount: Double = 0.0
    var bookedOrderNumber = ""
    var finalAmountBill = ""
    
    var delegate: UpdateWaitingList?
    
//    var waitListCount: Int?
    var waitList: [SelectSeats]?
    
    var available_slots = 0 //self.chef_detail?.availableSlots ?? 0
    var filled_slots = 0 //self.chef_detail?.filledSlots ?? 0
    var maximumReserved = 0//self.chef_detail?.dining?.guestsBooking ?? 0
    var totalSeats = 0 //self.chef_detail?.totalSeats ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWhite
        viewControllerTitle = "Book Your Experience"
//        self.chef_detail?.wBalance = 0
        self.currentMonthName = self.chef_detail?.months?.first ?? ""
        setupUI()
        registerCells()
        
        let attributeString = NSMutableAttributedString(
            string: "You can add guest to waitlist",
            attributes: yourAttributes
        )
        addGuestWaitlistBtn.setAttributedTitle(attributeString, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(bookingConfirm), name: NSNotification.Name.init(rawValue: "bookingConfirm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inviteGuest), name: NSNotification.Name.init(rawValue: "inviteGuest"), object: nil)
        
        self.partiallyBtn.borderColor = .white
        self.partiallyBtn.borderWidth = 0.5
        self.partiallyBtn.ibcornerRadius = 5
        
        let wBalance = Double(self.chef_detail?.wBalance ?? "0.0") ?? 0
        self.walletBalanceLbl.text = String(format: "( AED %.0f )", wBalance)
        
        self.waitingListView.isHidden = true
    }
    @objc private func bookingConfirm() {
//        Coordinator.showBookingConfirmAlert(delegate: self)
    }
    @objc private func inviteGuest() {
//        Coordinator.showAddGuestDetails(delegate: self, numberOfSeats: numberOfSeat)
    }
    private func setupUI() {
        self.monthSelectionBtn.setTitle("\(self.currentMonthName) \(Date().currentYear)" , for: .normal)
        setupModel()
    }
    private func setupModel() {
        calendarData = self.chef_detail?.dates?.filter({ dates in
            dates.month == self.currentMonthName
        })
        if isFirstLoad {
            if let c = calendarData?.count {
                if c > 0 {
                    self.calendarData?[0].isSelected = true
                    isFirstLoad = false
                }
            }
        }
        calendarCollectionView.reloadData()
        
        timeSlots = [
            AvailableTimeSlots(timeSlot: self.chef_detail?.time ?? "", isSelected: true)
        ]
        timeSlotCollectionView.reloadData()
        
        if let c = calendarData?.count {
            if c > 0 {
                getTimeAccDate(date: calendarData?[0].dates ?? "")
            }
        }
        self.guestBookingSeats = self.chef_detail?.dining?.guestsBooking ?? 0
        self.totalSeatsLbl.text = "Total Seats: \(self.chef_detail?.totalSeats ?? 0)"
        self.guestBookingLbl.text = "(maximum \(guestBookingSeats) seats can be booked)"
        
        setupBillDetails()
//        setupPartiallyPayment()
    }
    private func getTimes() {
        numberOfSeatHeight.constant = 225
        bookSeats = [SelectSeats]()
        waitList = nil
        numberOfSeatHeight.constant -= waitingListHeight.constant
        waitingListHeight.constant = 0
        if let dateWise = dateWise {
            for _ in 0..<(dateWise.filledSlots ?? 0) {
                bookSeats.append(SelectSeats(_f: true, _a: false, _s: false, _u: false, _w: false))
            }
            for _ in 0..<(dateWise.availableSlots ?? 0) {
                bookSeats.append(SelectSeats(_f: false, _a: true, _s: false, _u: false, _w: false))
            }
            available_slots = dateWise.availableSlots ?? 0
            filled_slots = dateWise.filledSlots ?? 0
            maximumReserved = self.chef_detail?.dining?.guestsBooking ?? 0
            totalSeats = dateWise.totalSeats ?? 0

        }
        bookingSlotCollectionView.reloadData()
        let height = self.bookingSlotCollectionView.collectionViewLayout.collectionViewContentSize.height
        numberOfSeatCollectionHeight.constant = height
        numberOfSeatHeight.constant += height
    }
    private func setupBillDetails() {
        self.billDetail = [BillDetail]()
        
        let numberOfPerson = self.bookSeats.filter { seats in
            seats.selectedSeat == true
        }.count
        
        
        var pricePerson = 0.0
        let discount = 0.0
        
        if let Discount = Double(self.chef_detail?.dining?.discountPrice ?? "0") {
            pricePerson = Discount
        }

        self.billDetail?.append(BillDetail(billTitle: "Experience cost of \(numberOfPerson)", billAmount: String(format: "AED %.2f", pricePerson * Double(numberOfPerson))))//"AED \(pricePerson * numberOfPerson)"))
        self.billDetail?.append(BillDetail(billTitle: "Discount", billAmount: String(format: "AED %.2f", discount)))// "AED \()"))
        self.billDetail?.append(BillDetail(billTitle: "Paid by Wallet", billAmount: String(format: "AED %.2f", self.paybyWallet))) // "AED \(self.paybyWallet)"))
        
        subTotal = (pricePerson * Double(numberOfPerson))// - (self.paybyWallet))
        self.billDetail?.append(BillDetail(billTitle: "Subtotal", billAmount: String(format: "AED %.2f", subTotal)))
        
        //adding VAT Field
        let vatValue = Double(self.chef_detail?.vatTax ?? "0") ?? 0.0
        let appliedVatValue = self.calculatePercentage(value: subTotal, percentageVal: vatValue)
        
        let vatString = String(format: "%.2f", vatValue)
        self.billDetail?.append(BillDetail(billTitle: "VAT \(vatString)% Included", billAmount: "AED 0.00"))
        
        tableViewHeightConstraint.constant = 93
        tableViewHeightConstraint.constant += CGFloat(billDetail!.count * 30)
        
        self.totalAmount = subTotal - discount
        self.grandTotal.text = String(format: "AED %.2f", self.totalAmount)
        self.tableView.reloadData()
        
        setupPartiallyPayment()
    }
    private func registerCells() {
        tableView.register(UINib(nibName: BillDetailDataTableCell.description(), bundle: nil), forCellReuseIdentifier: BillDetailDataTableCell.description())
        tableView.dataSource = self
        tableView.delegate = self
//        tableViewHeightConstraint.constant += CGFloat(billDetail.count * 30)
        
        calendarCollectionView.register(UINib(nibName: CalendarDatesCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: CalendarDatesCollectionCell.description())
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        timeSlotCollectionView.register(UINib(nibName: TimeSlotSelectionCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: TimeSlotSelectionCollectionCell.description())
        timeSlotCollectionView.delegate = self
        timeSlotCollectionView.dataSource = self
        
        
        bookingSlotCollectionView.register(UINib(nibName: BookingSlotsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: BookingSlotsCollectionCell.description())
        bookingSlotCollectionView.delegate = self
        bookingSlotCollectionView.dataSource = self
        
        waitingListCollectionView.register(UINib(nibName: BookingSlotsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: BookingSlotsCollectionCell.description())
        waitingListCollectionView.delegate = self
        waitingListCollectionView.dataSource = self
    }
    
    //
    private func getTimeAccDate(date: String) {
        HomeAPIManager.GetSeatsFromDate(dining: chef_detail?.dining?.id ?? 0, date: date) { result in
            switch result.status {
            case "Success":
                self.dateWise = result
                break
            case "Fail": break
            default: break
            }
        }
    }
    private func setupPartiallyPayment() {
        //MARK: PARTIAL PAT CONDITIONS
        //1. If grand total is more than wallet balance then check mark partial balance option and make it enable
        //2. If total is less then do not enable check mark by default but if user wants to enable it then he can
        //In point 1, if user uncheck partial payment option then still he can make full payment online
        //if Partial payment check is enabled, then User needs to enter wallet amount (if he/she have wallet balance)
        //and If Wallet Balance is 0, then user cannot enable PARTIAL PAYMENT, RIGHT?
        
        let wBalance = Double(self.chef_detail?.wBalance ?? "0")
        
        print("Grand Total: \(totalAmount)")
        print("Wallet Balance: \(wBalance!)")
        print("is GrandTotal is greater than Wallet Balance: \(totalAmount > wBalance!)")
        
//        if self.totalAmount >= wBalance! {
//            self.partiallyBtn.tag = 0
//            self.partiallyBtn.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.5)
//            return
//        }
        if self.totalAmount <= wBalance! {
            self.partiallyBtn.tag = 0
            self.partiallyBtn.backgroundColor = .clear
            return
        }
    }
    
    //MARK: Waiting list
    fileprivate func addUpdaiteWaitingList(index: Int?) {
        self.waitList = nil
        self.waitingListView.isHidden = true
        self.numberOfSeatHeight.constant -= self.waitingListHeight.constant
        switch index {
        case 0:
            var tempCount = 0
            for i in filled_slots..<totalSeats {
                if tempCount == maximumReserved {
                    break
                }
                self.bookSeats[i].selectedSeat = true
                self.bookSeats[i].availableSeat = false
                tempCount += 1
            }
            if tempCount == 0 {
                Utilities.showWarningAlert(message: "No seats available.")
                return
            }
            if let _ = self.waitList {
                self.waitingListView.isHidden = false
            }
            self.bookingSlotCollectionView.reloadData()
            self.setupBillDetails()
            break
        case 1:
            getTimes()
            var tempFilled = filled_slots
            for i in 0..<maximumReserved {
                let filledSeat = self.bookSeats.filter { seats in
                    seats.filledSeat == true
                }.count
                let selectedSeat = self.bookSeats.filter { seats in
                    seats.selectedSeat == true
                }.count
                let tempTotal = selectedSeat + filledSeat
                if totalSeats == tempTotal && i < maximumReserved {
                    if self.waitList == nil {
                        self.waitList = [SelectSeats(_f: false, _a: false, _s: false, _u: false, _w: true)]
                    } else {
                        self.waitList?.append(SelectSeats(_f: false, _a: false, _s: false, _u: false, _w: true))
                    }
                    continue
                }
                self.bookSeats[tempFilled].selectedSeat = true
                tempFilled += 1
            }
            if let _ = self.waitList {
                self.waitingListView.isHidden = false
                self.waitingListLbl.text = "Waiting List: \(self.waitList?.count ?? 0)"
            }
            self.setupBillDetails()
        case 2:
            getTimes()
            self.waitList = [SelectSeats]()
            for _ in 0..<maximumReserved {
                self.waitList?.append(SelectSeats(_f: false, _a: false, _s: false, _u: false, _w: true))
            }
            self.waitingListView.isHidden = false
            self.waitingListLbl.text = "Waiting List: \(maximumReserved)"
            break
        case 3:
            self.navigationController?.popToRootViewController(animated: true)
        default: break
        }
        self.waitingListCollectionView.reloadData()
        let height = self.waitingListCollectionView.collectionViewLayout.collectionViewContentSize.height
        waitingListHeight.constant = height
        numberOfSeatHeight.constant += height
    }
    
    @IBAction func partiallyTapped(_ sender: UIButton) {
        //MARK: PARTIAL PAY CONDITIONS
        if sender.tag == 0 {
            let wBalance = Double(self.chef_detail?.wBalance ?? "0")
            if wBalance! <= 0 {
                Utilities.showWarningAlert(message: "Insufficient balance.\nYou cannot do Partial Payment.")
                return
            }
            self.partialPayment = 1
            sender.tag = 1
            self.partiallyBtn.backgroundColor = Color.pinkPurple.color().withAlphaComponent(0.5)
        } else {
            self.partialPayment = 0
            sender.tag = 0
            self.partiallyBtn.backgroundColor = .clear
        }
    }
    
    @IBAction func checkoutBtnTapped(_ sender: Any) {
        let diningId = self.chef_detail?.dining?.id ?? 0
        let date = self.calendarData?.filter({ dates in
            dates.isSelected == true
        }).first?.dates ?? ""
        
        if date == "" {
            Utilities.showWarningAlert(message: "Please select date first")
            return
        }
        let time = self.timeSlots?.filter({ slot in
            slot.isSelected == true
        }).first?.timeSlot ?? ""
        
        if time == "" {
            Utilities.showWarningAlert(message: "Please select time first")
            return
        }
        
        let selectedSeats = self.bookSeats.filter { seats in
            seats.selectedSeat == true
        }.count
        
        if selectedSeats == 0 {
            Utilities.showWarningAlert(message: "Please select seats first")
            return
        }
        //MARK: PARTIAL PAY CONDITIONS
        //if Partial payment check is enabled, then User needs to enter wallet amount (if he/she have wallet balance)
        
        let wallet_amount = Double(self.chef_detail?.wBalance ?? "0") ?? 0
        let payByWalletAm = Double(self.payUsingWallet.text ?? "0") ?? 0
        
        if payByWalletAm > wallet_amount {
            Utilities.showWarningAlert(message: "Amount should be less than your wallet amount.")
            return
        }
        
        if radioButtons[0].isSelected {
            if self.payUsingWallet.text == "" || self.payUsingWallet.text == "0"{
                Utilities.showWarningAlert(message: "Please enter amount wallet amount.")
                return
            }
            let textAmount = Double(self.payUsingWallet.text ?? "0") ?? 0
            let wBalance = Double(self.chef_detail?.wBalance ?? "0.0") ?? 0.0
            if textAmount > wBalance {
                Utilities.showWarningAlert(message: "Amount should be less than your wallet amount.")
                return
            }
            if textAmount > totalAmount {
                Utilities.showWarningAlert(message: "Inserted amount is too big.")
                return
            }
        }
        if partiallyBtn.tag == 1 {
            let textAmount = Double(self.payUsingWallet.text ?? "0") ?? 0.0
            let wBalance = Double(self.chef_detail?.wBalance ?? "0.0") ?? 0.0
            
            if textAmount == 0 {
                Utilities.showWarningAlert(message: "Please enter wallet amount. or disabled Partial Payment Option")
                return
            }
            if textAmount > wBalance {
                Utilities.showWarningAlert(message: "Amount should be less or equal to your wallet amount.")
                return
            }
            if textAmount > totalAmount {
                Utilities.showWarningAlert(message: "Inserted amount is too big.")
                return
            }
//            if (self.chef_detail?.wBalance ?? 0) > 0 {
//                Utilities.showWarningAlert(message: "Partial payment is checked, you need to enter amount in Wallet section.")
//                return
//            }
        }
        
        if self.payUsingWallet.text != "" {
            self.partialPayment = 1
        }
        let waitListCount = self.waitList?.count ?? 0
        let params = [
            "dining_id" : diningId,
            "date" : date,
            "time" : time,
            "booked_seats" : "\(selectedSeats)",
            "chef_comments" : "\(self.commentsForChef.text ?? "")",
            "payment_type" : isPayWithCard ? ("CARD"): ("CASH"),
            "payment_status" : "PAID",
            "promo_code" : "\(self.promoCode.text ?? "")",
            "wallet_balance" : "\(self.payUsingWallet.text ?? "")",
            "partial_payment" : "\(self.partialPayment)",
            "subtotal" : subTotal,
            "discount" : 0,
            "total" : totalAmount,
            "waiting_users": waitListCount
        ] as [String: Any]
        
        if isPayWithCard {
            stripeDictAsParams = params
            getStripeRefKeyAPI()
            return
        }
        
        HomeAPIManager.BookingConfirm(params: params) { result in
            switch result.status {
            case "Success":
                self.numberOfSeat = result.confirmed_seats ?? ""
                self.bookedOrderNumber = result.order_number ?? ""
                Coordinator.showBookingConfirmAlert(delegate: self, orderNumber: result.order_number ?? "", navDelegate: self)
                break
            case "Fail":
                Utilities.showWarningAlert(message: result.message ?? "")
                break
            default: break
                
            }
        }
    }
    
    @IBAction func monthSelectionTapped(_ sender: Any) {
        var month_data = [MonthSelection]()
        self.chef_detail!.months!.forEach { month in
            month_data.append(MonthSelection(monthName: month, isSelected: false))
        }
        for (i, m) in month_data.enumerated() {
            if m.monthName == self.currentMonthName {
                month_data[i].isSelected = true
            }
        }
        Coordinator.showMonthSelectionAlert(vc: self, month_data: month_data, delegate: self)
    }
    @IBAction func paymentRadioTapped(_ sender: UIButton) {
        //MARK: PARTIAL PAY CONDITIONS
        //and If Wallet Balance is 0, then user cannot enable PARTIAL PAYMENT, RIGHT?
        sender.tag == 0 ? (isPayWithCard = false) : (isPayWithCard = true)
        if sender.tag == 0 {
            let wBalance = Double(self.chef_detail?.wBalance ?? "0.0") ?? 0.0
            if wBalance <= 0 {
                Utilities.showWarningAlert(message: "Insufficient Balance.\nYou cannot do payment via wallet.")
                return
            }
        }
//        sender.isSelected = !sender.isSelected
        self.radioButtons.forEach { btn in
            btn.setImage(UIImage(systemName: "circle"), for: .normal)
            btn.accessibilityLabel = "unselected"
            btn.isSelected = false
        }
        sender.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        sender.accessibilityLabel = "selected"
        sender.isSelected = true
    }
    
    @IBAction func addGuestWishlistTapped(_ sender: Any) {
        Coordinator.showSeatSelectionAlert(controller: self, delegate: self)
    }
}

extension BookYourExperienceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.billDetail?.count {
            return count
        }
        return 0
//        return billDetail.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillDetailDataTableCell.description()) as! BillDetailDataTableCell
        
        if let data = billDetail?[indexPath.row] {
            cell.detailLabel.text = data.billTitle
            cell.detailPrice.text = data.billAmount
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}


extension BookYourExperienceViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView {
            if let count = self.calendarData?.count {
                return count
            }
            return 0
        } else if collectionView == timeSlotCollectionView {
            if let count = self.timeSlots?.count {
                return count
            }
            return 0
        } else if collectionView == waitingListCollectionView {
            if let count = self.waitList?.count {
                return count
            }
            return 0
        } else {
            return bookSeats.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDatesCollectionCell.description(), for: indexPath) as! CalendarDatesCollectionCell
            if let calendarData = self.calendarData?[indexPath.row] {
                let monthDay = (calendarData.days ?? "").split(separator: " ")
                cell.monthName.text = String(monthDay.first!)
                cell.monthDate.text = String(monthDay.last!)
                if calendarData.isSelected ?? false {
                    cell.monthDate.textColor = Color.customPink.color()
                    cell.monthName.textColor = Color.customPink.color()
                    cell.backView.borderColor = Color.darkPurple.color()
                    cell.backView.borderWidth = 1.5
                    cell.backView.backgroundColor = Color.selectedColor.color()
                } else {
                    cell.monthDate.textColor = Color.underlineColor.color()
                    cell.monthName.textColor = Color.underlineColor.color()
                    cell.backView.borderColor = Color.underlineColor.color()
                    cell.backView.borderWidth = 1
                    cell.backView.backgroundColor = .clear
                }
            }
            return cell
        } else if collectionView == timeSlotCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeSlotSelectionCollectionCell.description(), for: indexPath) as! TimeSlotSelectionCollectionCell
            let data = self.timeSlots![indexPath.row]
            if data.isSelected {
                cell.backView.backgroundColor = Color.selectedColor.color()
                cell.backView.borderColor = Color.customPink.color()
                cell.backView.borderWidth = 1.5
                cell.timeLabel.textColor = Color.customPink.color()
            } else {
                cell.backView.backgroundColor = .clear
                cell.backView.borderColor = Color.underlineColor.color()
                cell.backView.borderWidth = 1.0
                cell.timeLabel.textColor = Color.underlineColor.color()
            }
            cell.timeLabel.text = data.timeSlot
            return cell
        } else if collectionView == waitingListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingSlotsCollectionCell.description(), for: indexPath) as! BookingSlotsCollectionCell
            
            if let data = self.waitList?[indexPath.row] {
                cell.slotView.backgroundColor = .clear
                cell.slotView.borderColor = .clear
                cell.slotView.borderWidth = 0
                if data.waitSeat {
                    cell.slotView.backgroundColor = Color.pinkPurple.color()
                } else {
                    cell.slotView.backgroundColor = .clear
                    cell.slotView.borderColor = Color.pinkPurple.color()
                    cell.slotView.borderWidth = 0.5
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingSlotsCollectionCell.description(), for: indexPath) as! BookingSlotsCollectionCell
            
            cell.slotView.backgroundColor = .clear
            cell.slotView.borderColor = .clear
            cell.slotView.borderWidth = 0
            let data = self.bookSeats[indexPath.row]
            if data.filledSeat {
                cell.slotView.backgroundColor = Color.filledSlot.color()
            } else if data.selectedSeat {
                cell.slotView.backgroundColor = Color.customPink.color()
            } else if data.availableSeat {
                cell.slotView.backgroundColor = .clear
                cell.slotView.borderColor = Color.filledSlot.color()
                cell.slotView.borderWidth = 0.5
            } else {
                cell.slotView.backgroundColor = .clear
                cell.slotView.borderColor = Color.customPink.color()
                cell.slotView.borderWidth = 0.5
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            if calendarData![indexPath.row].isSelected ?? false {
//                self.calendarData![indexPath.row].isSelected = false
//                self.bookSeats = [SelectSeats]()
//                self.bookingSlotCollectionView.reloadData()
            } else {
                for (i, _) in self.calendarData!.enumerated() {
                    self.calendarData![i].isSelected = false
                }
                self.calendarData![indexPath.row].isSelected = true
                self.getTimeAccDate(date: self.calendarData![indexPath.row].dates ?? "")
            }
            self.waitingListView.isHidden = true
            self.calendarCollectionView.reloadData()
        } else if collectionView == timeSlotCollectionView {
            if timeSlots![indexPath.row].isSelected {
                self.timeSlots![indexPath.row].isSelected = false
            } else {
                for (i, _) in timeSlots!.enumerated() {
                    timeSlots![i].isSelected = false
                }
                self.timeSlots![indexPath.row].isSelected = true
            }
            self.timeSlotCollectionView.reloadData()
        } else if collectionView == bookingSlotCollectionView {
            if bookSeats[indexPath.row].availableSeat {
                let selectedCount = self.bookSeats.filter { seat in
                    seat.selectedSeat == true
                }.count
                if selectedCount < self.guestBookingSeats {
                    self.bookSeats[indexPath.row].availableSeat = false
                    self.bookSeats[indexPath.row].selectedSeat = true
//                    self.setupBillDetails()
                } else {
                    Utilities.showWarningAlert(message: "You cannot select more than \(self.guestBookingSeats) seats.")
                }
            } else if bookSeats[indexPath.row].selectedSeat {
                self.bookSeats[indexPath.row].selectedSeat = false
                self.bookSeats[indexPath.row].availableSeat = true
            }
            self.setupBillDetails()
            self.bookingSlotCollectionView.reloadData()
        } else {
            if waitList![indexPath.row].waitSeat {
                self.waitList![indexPath.row].waitSeat = false
            } else {
                for (i, _) in waitList!.enumerated() {
                    waitList![i].waitSeat = false
                }
                self.waitList![indexPath.row].waitSeat = true
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calendarCollectionView {
            let size = self.calendarCollectionView.frame.size
            return CGSize(width: size.width/5, height: 105)
        } else if collectionView == timeSlotCollectionView {
            let size = self.timeSlotCollectionView.frame.size
            return CGSize(width: size.width/2, height: 50)
        } else {
//            let size = self.bookingSlotCollectionView.frame.size
            return CGSize(width: 37, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bookingSlotCollectionView || collectionView == waitingListCollectionView {
            return 5.0
        } else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bookingSlotCollectionView || collectionView == waitingListCollectionView {
            return 5.0
        } else {
            return 0.0
        }
    }
}

extension BookYourExperienceViewController: MonthSelectionDelegate {
    func monthSelectionDelegate(selected_month: MonthSelection?) {
        self.currentMonthName = selected_month?.monthName ?? ""
        self.setupUI()
    }
}

struct AvailableTimeSlots {
    var timeSlot: String
    var isSelected: Bool
}
class SelectSeats {
    var filledSeat: Bool = false
    var availableSeat: Bool = false
    var selectedSeat: Bool = false
    var unknownSeat: Bool = false
    var waitSeat: Bool = false
    
    init(_f: Bool, _a: Bool, _s: Bool, _u: Bool, _w: Bool) {
        self.filledSeat = _f
        self.availableSeat = _a
        self.selectedSeat = _s
        self.unknownSeat = _u
        self.waitSeat = _w
    }
}


class BillDetail {
    var billTitle: String
    var billAmount: String
    
    init(billTitle: String, billAmount: String) {
        self.billTitle = billTitle
        self.billAmount = billAmount
    }
}
extension BookYourExperienceViewController: NavigateToInviteGuest {
    func navigateToInviteGuest() {
        Coordinator.showAddGuestDetails(delegate: self, numberOfSeats: numberOfSeat, order_number: self.bookedOrderNumber, chefId: self.chef_detail?.dining?.id ?? 0)
    }
}

// MARK: - Stripe Integration
extension BookYourExperienceViewController {
    fileprivate func launchStripePaymentSheet() {
        if secretkey.isEmpty {
            Utilities.showWarningAlert(message: "Secret key format does not match expected identifer formatting")
            return
        }
        var paymentSheetConfiguration = PaymentSheet.Configuration()
        paymentSheetConfiguration.merchantDisplayName = "Splidu"
        paymentSheetConfiguration.style = .alwaysLight
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: secretkey, configuration: paymentSheetConfiguration)
        self.paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
                
            case .completed:
                print("payment completed")
                self.makeBookingWithCard()
                
            case .canceled:
                print("User Cancelled")
                
            case .failed(_):
                print("Failed")
            }
        }
    }
    
    fileprivate func getStripeRefKeyAPI() {
        let param = HomeAPIManager.StripeAPIParams(amount: "\(totalAmount)")
        HomeAPIManager.getStripeRefrenceAPI(params: param) { [self] result in
            guard let result = result else {
                return
            }
            self.transID = result.transactionID
            self.secretkey = result.paymentRefrence
            launchStripePaymentSheet()
        }
    }
    
    fileprivate func makeBookingWithCard() {
        stripeDictAsParams.updateValue(transID, forKey: "transaction_id")
        HomeAPIManager.BookingConfirm(params: stripeDictAsParams) { result in
            switch result.status {
            case "Success":
                self.numberOfSeat = result.confirmed_seats ?? ""
                self.bookedOrderNumber = result.order_number ?? ""
                Coordinator.showBookingConfirmAlert(delegate: self, orderNumber: result.order_number ?? "", navDelegate: self)
                break
            case "Fail":
                Utilities.showWarningAlert(message: result.message ?? "")
                break
            default: break
                
            }
        }
    }
    
    fileprivate func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
}

extension BookYourExperienceViewController: UpdateWaitingList {
    func updateWaitingList(index: Int) {
        self.addUpdaiteWaitingList(index: index)
    }
}
