//
//  WalletViewController.swift
//  Splidu
//
//  Created by Rafi on 02/09/2022.
//

import UIKit

class WalletViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var walletModel: MyWalletModel? {
        didSet {
            self.walletIdLabel.text = walletModel?.data?.walletID ?? ""
            let amount = Double(walletModel?.data?.wallet?.balance ?? "0") ?? 0.0
            self.amountLabel.text = String(format: "%.2f", amount)
            self.equalLabel.text = String(format: "Equal to AED %.2f", amount)
            
            let _date = walletModel?.lastTransaction?.updatedAt ?? ""
            self.lastTransactionDate.text = "Last updated on \(self.getdateFormatted(_date: _date, isTime: true))"
            
            let totalSpent = Double(walletModel?.lastTransaction?.amount ?? "0") ?? 0.0
            self.totalSpentLabel.text = String(format: "Total Spent: AED %.2f", totalSpent)
            //            self.amountLabel.text =
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var walletIdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var equalLabel: UILabel!
    @IBOutlet weak var lastTransactionDate: UILabel!
    @IBOutlet weak var totalSpentLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backBlack
        viewControllerTitle = "My Wallet"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WalletHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: WalletHistoryTableViewCell.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWalletData()
    }
    
    
    @IBAction func copyActionBtnTap(_ sender: Any) {
        UIPasteboard.general.string = walletIdLabel.text
        Toast.show(message: "Wallet ID copied", controller: self)
    }
    
    private func getWalletData() {
        ProfileAPIManager.GetMyWallet { walletModel in
            switch walletModel.status {
            case "Success":
                self.walletModel = walletModel
                break
            case "Fail":
                //                self.
                break
            default: break
            }
        }
    }
    
    fileprivate func getdateFormatted(_date:String, isTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: _date)
        if isTime {
            dateFormatter.dateFormat = "d MMMM yyyy h:mm a"
        } else {
            dateFormatter.dateFormat = "d MMM yyyy"
        }
        
        let strDate = dateFormatter.string(from: date ?? Date())
        return strDate
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.walletModel?.data?.wallet?.history?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WalletHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryTableViewCell.cellIdentifier) as! WalletHistoryTableViewCell
        if let data = self.walletModel?.data?.wallet?.history?[indexPath.row] {
            cell.walletTitle.text = data.lastTransactionDescription ?? ""
            cell.dateLbl.text = getdateFormatted(_date: data.updatedAt ?? "", isTime: false)
            cell.amountLbl.text = "+AED \(data.amount ?? "0.00")"
        }
        return cell
    }
}
