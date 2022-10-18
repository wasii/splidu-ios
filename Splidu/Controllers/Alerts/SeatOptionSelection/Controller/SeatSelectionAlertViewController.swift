//
//  SeatSelectionAlertViewController.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit

class SeatSelectionAlertViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let data = [ "Book the available seats",
                 "Book the available seats and put the rest on the waitlist",
                 "Add all to the waitlist & get notified if/When seats are available",
                 "Explore other experiences"]
    
    var delegate: UpdateWaitingList?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func registerCells() {
        tableView.register(UINib(nibName: SeatOptionSelectionTableCell.description(), bundle: nil), forCellReuseIdentifier: SeatOptionSelectionTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SeatSelectionAlertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeatOptionSelectionTableCell.description()) as! SeatOptionSelectionTableCell
        
        cell.optionLabel.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.updateWaitingList(index: indexPath.row)
//            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "bookingConfirm"), object: nil)
        }
    }
}
