//
//  NotificationsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 08/09/2022.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .notifications
        viewControllerTitle = "Notifications"
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: NotificationTableCell.description(), bundle: nil), forCellReuseIdentifier: NotificationTableCell.description())
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableCell.description()) as! NotificationTableCell
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
}
