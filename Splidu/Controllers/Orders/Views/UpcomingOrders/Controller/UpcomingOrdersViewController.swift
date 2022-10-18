//
//  UpcomingOrdersViewController.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class UpcomingOrdersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var order: [OrderDetails]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    private func registerCells() {
        tableView.register(UINib(nibName: OrdersTableCell.description(), bundle: nil), forCellReuseIdentifier: OrdersTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpcomingOrders(notification:)), name: .UpcomingOrders, object: nil)
    }
    @objc private func setUpcomingOrders(notification: Notification) {
        if let orders = notification.userInfo?["upcoming"] as? [OrderDetails] {
            self.order = orders
        }
    }
}

extension UpcomingOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.statusBtn.tag = indexPath.row
            cell.statusBtn.addTarget(self, action: #selector(showEventDetailScreen(sender:)), for: .touchUpInside)
            cell.waitingListBtn.isHidden = false
            var waitingConfirmed = ""
            if (order_data.confirmed ?? 0) > 1 {
                waitingConfirmed = "\(order_data.confirmed ?? 0) seats are confirmed "
            } else {
                waitingConfirmed = "\(order_data.confirmed ?? 0) seat is confirmed "
            }
            if (order_data.waiting ?? 0) > 1 {
                waitingConfirmed += "& \(order_data.waiting ?? 0) seats are in waitinglist"
            } else {
                waitingConfirmed += "& \(order_data.waiting ?? 0) seat is in waitinglist"
            }
            
            cell.waitingListBtn.setTitle(waitingConfirmed, for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderId = self.order![indexPath.row].confirmNumber ?? ""
        Coordinator.showEventDetails(delegate: self, orderId: orderId)
    }
    
    @objc private func showEventDetailScreen(sender: UIButton) {
//        let orderId = self.order![sender.tag].confirmNumber ?? ""
//        Coordinator.showEventDetails(delegate: self, orderId: orderId)
    }
}
