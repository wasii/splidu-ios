//
//  MonthSelectionViewController.swift
//  Splidu
//
//  Created by abdWasiq on 01/09/2022.
//

import UIKit
protocol MonthSelectionDelegate {
    func monthSelectionDelegate(selected_month: MonthSelection?)
}
class MonthSelectionViewController: BaseViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var month_data: [MonthSelection]?
    let data = ["january", "february", "march", "april", "may", "june", "july", "august"]
    
    var delegate: MonthSelectionDelegate?
    var selected_month: MonthSelection?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
//        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        backView.backgroundColor = Color.customBlack.color().withAlphaComponent(0.5)
    }
    override func viewWillAppear(_ animated: Bool) {
        createBlur()
    }
    private func createBlur() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let visualBlurEffect = UIVisualEffectView(effect: blurEffect)
        visualBlurEffect.frame = view.bounds
        visualBlurEffect.alpha = 0.7
        backView.addSubview(visualBlurEffect)
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func proceedBtnTapped(_ sender: Any) {
        if selected_month == nil {
            return
        }
        self.dismiss(animated: true) {
            self.delegate?.monthSelectionDelegate(selected_month: self.selected_month)
        }
    }
    private func registerCells() {
        collectionView.register(UINib(nibName: SelectMonthCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: SelectMonthCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

extension MonthSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = month_data?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMonthCollectionCell.description(), for: indexPath) as! SelectMonthCollectionCell
        
        let data = month_data![indexPath.row]
        cell.monthLabel.text = data.monthName.uppercased()
        if data.isSelected {
            cell.backView.borderColor = Color.customPink.color()
            cell.monthLabel.textColor = Color.customPink.color()
        } else {
            cell.backView.borderColor = .white
            cell.monthLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if month_data![indexPath.row].isSelected {
            self.month_data![indexPath.row].isSelected = false
        } else {
            for (i, _) in month_data!.enumerated() {
                month_data![i].isSelected = false
            }
            self.month_data![indexPath.row].isSelected = true
        }
        self.selected_month = self.month_data![indexPath.row]
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width/3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


struct MonthSelection {
    var monthName: String
    var isSelected: Bool
}
