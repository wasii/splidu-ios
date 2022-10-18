//
//  CancelledOrdersViewController.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class CancelledOrdersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var order: [OrderDetails]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpcomingOrders(notification:)), name: .CancelledOrders, object: nil)
    }
    private func registerCells() {
        tableView.register(UINib(nibName: OrdersTableCell.description(), bundle: nil), forCellReuseIdentifier: OrdersTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    @objc private func setUpcomingOrders(notification: Notification) {
        if let orders = notification.userInfo?["cancelled"] as? [OrderDetails] {
            self.order = orders
        }
    }
}

extension CancelledOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
        if let count = self.order?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableCell.description()) as! OrdersTableCell
        if let order_data = self.order?[indexPath.row] {
            cell.orderName.text = order_data.confirmNumber ?? ""
            cell.address.text = order_data.dining?.location ?? ""
            cell.dateLabel.text = order_data.ordermain?.diningDate ?? ""
            cell.priceLabel.text = "AED " + (order_data.total ?? "")
            
            cell.statusBtn.setTitle(order_data.orderStatus ?? "", for: .normal)
        
            cell.waitingListBtn.isHidden = true
            cell.viewLoacationView.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

