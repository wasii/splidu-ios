//
//  FavoriteChefsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 03/09/2022.
//

import UIKit

class FavoriteChefsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    private func registerCells() {
        tableView.register(UINib(nibName: HomeCategoryListingTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeCategoryListingTableCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FavoriteChefsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryListingTableCell.description()) as! HomeCategoryListingTableCell
        
        cell.ratingView.isHidden = false
        cell.shareBtn.isHidden = true
        
        return cell
    }
}
