//
//  MessagesViewController.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit

class MessagesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.title = "Messages"
        type = .messages
    }

    fileprivate func registerCells() {
        tableView.register(UINib(nibName: messageTableViewCell.description(), bundle: nil), forCellReuseIdentifier: messageTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: messageTableViewCell = tableView.dequeueReusableCell(withIdentifier: messageTableViewCell.description()) as! messageTableViewCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Coordinator.conversation(delegate: self)
    }
}


