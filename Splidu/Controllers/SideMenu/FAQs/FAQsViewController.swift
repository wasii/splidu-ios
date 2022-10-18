//
//  FAQsViewController.swift
//  Splidu
//
//  Created by abdWasiq on 05/09/2022.
//

import UIKit

class FAQsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections = [FAQs]()
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backBlack
        viewControllerTitle = "FAQs"
        registerCells()
        
        sections = [
            FAQs(_header: "Pellentesque iaculis velit sit amet ligula eleifend ultricies ?",
                     _option: ["Pellentesque iaculis velit sit amet ligula eleifend ultricies ?"],
                     _isOpened: false),
            FAQs(_header: "Pellentesque iaculis velit sit amet ligula eleifend ultricies ?",
                     _option: ["Pellentesque iaculis velit sit amet ligula eleifend ultricies ?"],
                     _isOpened: false),
            FAQs(_header: "Pellentesque iaculis velit sit amet ligula eleifend ultricies ?",
                     _option: ["Pellentesque iaculis velit sit amet ligula eleifend ultricies ?"],
                     _isOpened: false),
            FAQs(_header: "Pellentesque iaculis velit sit amet ligula eleifend ultricies ?",
                     _option: ["Pellentesque iaculis velit sit amet ligula eleifend ultricies ?"],
                     _isOpened: false),
            FAQs(_header: "Pellentesque iaculis velit sit amet ligula eleifend ultricies ?",
                     _option: ["Pellentesque iaculis velit sit amet ligula eleifend ultricies ?"],
                     _isOpened: false)
        ]
    }
    private func registerCells() {
        tableView.register(UINib(nibName: FAQsSeactionTableCell.description(), bundle: nil), forCellReuseIdentifier: FAQsSeactionTableCell.description())
        tableView.register(UINib(nibName: FAQsDetailTableCell.description(), bundle: nil), forCellReuseIdentifier: FAQsDetailTableCell.description())
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FAQsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.option.count + 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FAQsSeactionTableCell.description()) as! FAQsSeactionTableCell
            cell.sectionLabel.text = sections[indexPath.section].header
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FAQsDetailTableCell.description()) as! FAQsDetailTableCell
            
            cell.detailLabel.text = sections[indexPath.section].option[indexPath.row - 1]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


class FAQs {
    var header: String
    var option: [String]
    var isOpened: Bool = false
    
    init(_header: String, _option: [String], _isOpened: Bool = false) {
        self.header = _header
        self.option = _option
        self.isOpened = _isOpened
    }
}
