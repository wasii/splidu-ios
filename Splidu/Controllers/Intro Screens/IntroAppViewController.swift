//
//  IntroAppViewController.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit
import FSPagerView

class IntroAppViewController: BaseViewController {

    @IBOutlet weak var cPageControl: FSPageControl! {
        didSet {
            self.cPageControl.numberOfPages = 3
            self.cPageControl.contentHorizontalAlignment = .center
            self.cPageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.cPageControl.hidesForSinglePage = true
            self.cPageControl.setImage(UIImage(named:"unselected-pagecontrol"), for: .normal)
            self.cPageControl.setImage(UIImage(named:"selected-pagecontrol"), for: .selected)
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipActionBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var items: [[String:String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: AppIntroCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: AppIntroCollectionCell.description())
        collectionView.dataSource = self
        collectionView.delegate = self
        
        items = [["title": "Chef Hiring", "value": "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock", "image": "introImage1"],
                 ["title": "Restaurant Reservation", "value": "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock", "image": "introImage2"],
                 ["title": "Underground Events", "value": "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock", "image": "introImage3"]]

    }
    
    @IBAction func skipActionBtnTap(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isAppIntroduced)
        Coordinator.LoginScreen()
    }
}

extension IntroAppViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppIntroCollectionCell.description(), for: indexPath) as? AppIntroCollectionCell else {
            fatalError()
        }
        let data = items![indexPath.row]
        cell.titleLabel.text = data["title"]
        cell.introText.text = data["value"]
        cell.introImage.image = UIImage(named: data["image"]!)
        cell.isShowNextActionBtn = true
        cell.didTapOnNextActionBtn = { [self] in
            if (self.items?.count ?? 0) - 1 == indexPath.row {
                UserDefaults.standard.set(true, forKey: UserDefaults.AppUserDefault.isAppIntroduced)
                Coordinator.LoginScreen()
            } else {
                cPageControl.currentPage = indexPath.row + 1
                let index_Path = IndexPath(row: indexPath.row + 1, section: 0)
                collectionView.scrollToItem(at: index_Path, at: .centeredHorizontally, animated: true)
                if (items?.count ?? 0) - 1 == indexPath.row + 1 {
                    skipActionBtn.isHidden = true
                } else { skipActionBtn.isHidden = false }
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        cPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if cPageControl.currentPage == 2 {
            skipActionBtn.isHidden = true
        } else { skipActionBtn.isHidden = false }
    }
}

extension IntroAppViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let size = self.collectionView.frame.size
           return CGSize(width: size.width, height: size.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0.0
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0.0
       }
    
}
