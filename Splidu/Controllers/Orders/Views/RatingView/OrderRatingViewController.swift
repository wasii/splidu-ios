//
//  OrderRatingViewController.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class OrderRatingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        type = .backBlack
        viewControllerTitle = "Rate your Experience"
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: RatingOrderTableCell.description(), bundle: nil), forCellReuseIdentifier: RatingOrderTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewHeightConstraint.constant = 500
        mainViewHeightConstraint.constant += tableViewHeightConstraint.constant
    }
}

extension OrderRatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingOrderTableCell.description()) as! RatingOrderTableCell
        
        switch indexPath.row {
        case 0:
            cell.rateImage.image = UIImage(named: "food-quality")!
            cell.rateTitle.text = "Food Quality/Taste"
            break
        case 1:
            cell.rateImage.image = UIImage(named: "person-behaviour")!
            cell.rateTitle.text = "Persona/Behavior/Presentation"
            break
        case 2:
            cell.rateImage.image = UIImage(named: "communication")!
            cell.rateTitle.text = "Communication"
            break
        case 3:
            cell.rateImage.image = UIImage(named: "experience")!
            cell.rateTitle.text = "Experience"
            break
        case 4:
            cell.rateImage.image = UIImage(named: "overall-rating")!
            cell.rateTitle.text = "Overall Rating"
            break
        default: break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
