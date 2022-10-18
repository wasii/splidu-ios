//
//  ConversationViewController.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit

class ConversationViewController: BaseViewController {

    
    let arr = ["Hello ", "Hello", "A very common task in iOS is to provide auto sizing cells for UITableView components.", "A very common task in iOS is to provide auto sizing cells", "A very common task in iOS is to provide auto sizing cells for UITableView components.", "A very common task in iOS is to provide auto sizing cells for UITableView components."]
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        viewControllerTitle = "Messages"
        type = .backBlack
    }

    fileprivate func registerCells() {
        tableView.register(UINib(nibName: OutgoingTableViewCell.description(), bundle: nil), forCellReuseIdentifier: OutgoingTableViewCell.description())
        tableView.register(UINib(nibName: IncomingTableViewCell.description(), bundle: nil), forCellReuseIdentifier: IncomingTableViewCell.description())

        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension ConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outgoingCell: OutgoingTableViewCell = tableView.dequeueReusableCell(withIdentifier: OutgoingTableViewCell.description()) as! OutgoingTableViewCell
        let incomingCell: IncomingTableViewCell = tableView.dequeueReusableCell(withIdentifier: IncomingTableViewCell.description()) as! IncomingTableViewCell
        if indexPath.row % 2 == 0 {
            outgoingCell.messageLabel.text = arr[indexPath.row]
            return outgoingCell
        }
        else{
            incomingCell.messageLabel.text = arr[indexPath.row]
            return incomingCell
        }
        
        return UITableViewCell()
        
    }
    
}
