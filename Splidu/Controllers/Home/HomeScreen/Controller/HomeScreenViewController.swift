//
//  HomeScreenViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit
import FSPagerView
import SDWebImage

class HomeScreenViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagerVieiw: FSPagerView! {
        didSet {
            self.pagerVieiw.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 0
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
//            self.pageControl.numberOfPages = 0
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.hidesForSinglePage = true
            self.pageControl.setImage(UIImage(named:"unselected-pagecontrol"), for: .normal)
            self.pageControl.setImage(UIImage(named:"selected-pagecontrol"), for: .selected)
        }
    }
    
    @IBOutlet weak var cPageControl: FSPageControl! {
        didSet {
//            self.cPageControl.numberOfPages = 0
            self.cPageControl.contentHorizontalAlignment = .center
            self.cPageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.cPageControl.hidesForSinglePage = false
            self.cPageControl.setImage(UIImage(named:"unselected-pagecontrol"), for: .normal)
            self.cPageControl.setImage(UIImage(named:"selected-pagecontrol"), for: .selected)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var varietiesTableView: UITableView!
    @IBOutlet weak var varietiesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredChefView: UIView!
    @IBOutlet weak var featuredChefTableView: UITableView!
    
    fileprivate var typeIndex = 0 {
        didSet {
            self.pagerVieiw.transformer = FSPagerViewTransformer(type:.linear)
            let transform = CGAffineTransform(scaleX: 0.89, y: 1)
            self.pagerVieiw.itemSize = self.pagerVieiw.frame.size.applying(transform)
            self.pagerVieiw.decelerationDistance = FSPagerView.automaticDistance
        }
    }
    
    let imageNames = ["Mask group", "Mask group", "Mask group", "Mask group"]
    var categories : [Category]?
    var baseURL = ""
    
    var homeModel: HomeModel? {
        didSet {
            self.baseURL = homeModel?.baseURL ?? ""
            if let count = self.homeModel?.sliders?.count {
                self.pageControl.currentPage = 0
                self.pageControl.numberOfPages = count
                self.startTimer()
            }
            if let count = self.homeModel?.categories?.count {
                if count > 8 {
                    self.cPageControl.numberOfPages = 2
                } else {
                    self.cPageControl.numberOfPages = 1
                }
            }
            self.collectionView.reloadData()
//            self.pagerVieiw.reloadData()
//            self.categoriesCollectionView.reloadData()
            self.setCategoriesOrder()
            self.varietiesTableView.reloadData()
            if let _ = self.homeModel?.featuredChefs {
                self.featuredChefView.isHidden = false
                self.featuredChefTableView.reloadData()
            }
        }
    }
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var itemSize = CGSize(width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registerCell()
        
        //Making API Call
        getServerData()
    }
    override func viewDidAppear(_ animated: Bool) {
        setHomeScreen()
    }
    private func startTimer() {
        _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    var x = 1
    @objc func scrollAutomatically(_ timer1: Timer) {
        if self.x < self.homeModel?.sliders?.count ?? 0 {
            let indexPath = IndexPath(item: x, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
            self.pageControl.currentPage = x
        } else {
            self.x = 0
            self.pageControl.currentPage = x
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
    private func setCategoriesOrder() {
        DispatchQueue.main.async {
            self.categories = self.homeModel?.categories?.sorted(by: { c1, c2 in
                c1.id ?? 0 < c2.id ?? 0
            })
            self.categoriesCollectionView.reloadData()
            let cHeight = self.categoriesCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.categoriesCollectionHeight.constant = cHeight + 30
        }
        
    }
    private func registerCell() {
        ///register cells
        
        collectionView.register(UINib(nibName: HomeHeaderCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeHeaderCollectionCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = sectionInsets
            layout.scrollDirection = .horizontal
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.isPagingEnabled = false
        view.layoutIfNeeded()
        
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        itemSize = CGSize(width: width, height: height)
        view.layoutIfNeeded()
        
        
        categoriesCollectionView.register(UINib(nibName: HomeCategoryCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: HomeCategoryCollectionCell.description())
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
//
        varietiesTableView.register(UINib(nibName: HomeVarietiesTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeVarietiesTableCell.description())
        varietiesTableView.delegate = self
        varietiesTableView.dataSource = self
        varietiesHeightConstraint.constant = 240 * 3
        
        
        featuredChefTableView.register(UINib(nibName: HomeVarietiesTableCell.description(), bundle: nil), forCellReuseIdentifier: HomeVarietiesTableCell.description())
        featuredChefTableView.delegate = self
        featuredChefTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
    }
    @IBAction func arrowupBtnTapped(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    private func getServerData() {
        HomeAPIManager.homeAPI { homemodel in
            switch homemodel.status {
            case "Success":
                self.homeModel = homemodel
                break
            default: break
            }
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == featuredChefTableView {
            if let _ = self.homeModel?.featuredChefs {
                return 1
            }
            return 0
        } else {
            if let count = self.homeModel?.dinings?.count {
                self.varietiesHeightConstraint.constant = CGFloat(240 * count)
                return count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == featuredChefTableView {
            return 1
        } else {
            if let count = self.homeModel?.dinings?.count {
                return count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeVarietiesTableCell.description()) as? HomeVarietiesTableCell else {
            fatalError()
        }
        if tableView == featuredChefTableView {
            let featuredChef_data = self.homeModel?.featuredChefs
            cell.titleLabel.text = "Featured Chef".uppercased()//eaturedChef_data?[indexPath.row].name?.uppercased() ?? ""
            cell.baseUrl = self.homeModel?.baseURL
            cell.featuredChefData = featuredChef_data
            
        } else {
            let chef_data = self.homeModel?.dinings
            cell.titleLabel.text = chef_data?[indexPath.row].title?.uppercased() ?? ""
            cell.baseUrl = self.homeModel?.baseURL
            cell.diningData = chef_data?[indexPath.row].data
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if let count = self.homeModel?.sliders?.count {
                return count
            }
            return 0
        } else {
            if let count = self.categories?.count {
                return count
            }
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionCell.description(), for: indexPath) as! HomeHeaderCollectionCell
            if let data = self.homeModel?.sliders?[indexPath.row] {
                let image = URL(string: (self.homeModel!.baseURL ?? "")+data.image!)!
                cell.headerImage.sd_setImage(with: image)
                
                cell.titleLbl.text = data.title ?? ""
                cell.descLbl.text = data.categoryDescription ?? ""
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionCell.description(), for: indexPath) as? HomeCategoryCollectionCell else {
                fatalError()
            }
            if let data = self.categories?[indexPath.row] {
                cell.categoryTitle.text = data.title
                if let image = data.image {
                    let url = URL(string: self.baseURL+image)
                    cell.categoryImage.sd_setImage(with: url, placeholderImage: UIImage(named: "homeIcon")!)
                } else {
                    cell.categoryImage.image = UIImage(named: "homeIcon")
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
//            if (indexPath.row % 8) == 0 {
//                let mainHeading = self.homeModel!.categories![indexPath.row].title ?? ""
//                Coordinator.showHomeCategoryScreen(delegate: self, mainHeading: mainHeading)
//            }
            if indexPath.row == 0 {
                if let data = self.categories?[indexPath.row] {
                    let mainHeading = data.title ?? ""
                    Coordinator.showHomeCategoryScreen(delegate: self, mainHeading: mainHeading)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            return sectionInsets
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return itemSize
        } else {
            let size = self.categoriesCollectionView.frame.size
            return CGSize(width: size.width/4, height: 105)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return sectionInsets.left
        } else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.categoriesPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = itemSize.width
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
            print("swipe right")
        } else {
            print("swipe left")
        }
        
        var index = Int( round((scrollView.contentOffset.x/pageWidth)+factor) )
        if index < 0 {
            index = 0
        }
        if index > imageNames.count-1 {
            index = imageNames.count-1
        }
        let indexPath = IndexPath(row: index, section: 0)
        if let count = self.homeModel?.sliders?.count {
            if count == index {
                let indexP = IndexPath(row: count - 1, section: 0)
                collectionView?.scrollToItem(at: indexP, at: .left, animated: true)
                return
            }
        }
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
        self.pageControl.currentPage = index//Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}


extension HomeScreenViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return imageNames.count
        if let count = self.homeModel?.sliders?.count {
            return count
        }
        return 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        cell.contentView.layer.shadowRadius = 3
        cell.contentView.layer.shadowOpacity = 0.3
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
}
