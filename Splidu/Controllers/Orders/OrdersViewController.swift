//
//  OrdersViewController.swift
//  Splidu
//
//  Created by abdWasiq on 30/08/2022.
//

import UIKit
import PagingKit

class OrdersViewController: BaseViewController {
    var tempIndex = 0
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    let focusView = UnderlineFocusView()
    
    lazy var firstLoad: (() -> Void)? = { [weak self, menuViewController, contentViewController] in
        menuViewController?.reloadData()
        contentViewController?.reloadData { [weak self] in
//            self?.adjustfocusViewWidth(index: 0, percent: 0)
        }
        self?.firstLoad = nil
    }
    
    let dataSource: [(menu: String, content: UIViewController)] = ["UPCOMING", "CANCELLED", "COMPLETED"].map {
        let title = $0
        if title == "UPCOMING" {
            let vc = Storyboard.orders.instantiate(identifier: UpcomingOrdersViewController.self)
            return (menu: title, content: vc)
        } else if title == "CANCELLED" {
            let vc = Storyboard.orders.instantiate(identifier: CancelledOrdersViewController.self)
            return (menu: title, content: vc)
        } else {
            let vc = Storyboard.orders.instantiate(identifier: CompletedOrdersViewController.self)
            return (menu: title, content: vc)
        }
    }
    
    var ordersModel: OrdersModel? {
        didSet {
            let upcoming = ordersModel?.orders?.filter({ o in
                o.type == "Inprocess Orders"
            }).first?.orders
            let cancelled = ordersModel?.orders?.filter({ o in
                o.type == "Cancel Orders"
            }).first?.orders
            let completed = ordersModel?.orders?.filter({ o in
                o.type == "Completed Orders"
            }).first?.orders
            
            NotificationCenter.default.post(name: .UpcomingOrders, object: nil, userInfo: ["upcoming" : upcoming])
            NotificationCenter.default.post(name: .CancelledOrders, object: nil, userInfo: ["cancelled" : cancelled])
            NotificationCenter.default.post(name: .CompleteOrder, object: nil, userInfo: ["completed" : completed])
        }
    }
    var isFromProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController.register(nib: UINib(nibName: OrdersHeaderTableCell.description(), bundle: nil), forCellWithReuseIdentifier: OrdersHeaderTableCell.description())
        
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFromProfile {
            type = .backBlack
            viewControllerTitle = "My Order"
        } else {
            self.title = "Orders"
            type = .orders
        }
        OrdersAPIManager.GetAllOrders { orders in
            switch orders.status {
            case "Success":
                self.ordersModel = orders
                break
            case "Fail":
                break
            default: break
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstLoad?()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController  {
            contentViewController = vc
            contentViewController?.dataSource = self
            contentViewController?.delegate = self
        }
    }
}

extension OrdersViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
        tempIndex = page
        menuViewController.reloadData()
    }
}
extension OrdersViewController: PagingMenuViewControllerDataSource {
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: OrdersHeaderTableCell.description(), for: index)  as! OrdersHeaderTableCell
        if tempIndex == index {
            cell.menuLabel.textColor = Color.darkGray.color().withAlphaComponent(1)
        } else {
            cell.menuLabel.textColor = Color.darkGray.color().withAlphaComponent(0.3)
        }
        cell.menuLabel.text = dataSource[index].menu
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return viewController.view.bounds.width / 3.5
    }
    
    var insets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
}

extension OrdersViewController: PagingContentViewControllerDataSource,PagingContentViewControllerDelegate {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
        
    }
    func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int) {
        print(index)
        tempIndex = index
        menuViewController.reloadData()
    }
}

