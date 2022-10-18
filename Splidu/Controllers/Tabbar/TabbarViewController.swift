//
//  TabbarViewController.swift
//  Splidu
//
//  Created by abdWasiq on 29/08/2022.
//

import UIKit

import UIKit
var isWhite: Bool = true
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    let btnHome = UIButton(type: .custom)
    var tabbar: TabBarSubViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        ////        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.darkTabbar.color()], for: .selected)
        //        tabBar.backgroundImage = UIImage()
        //        tabBar.shadowImage = UIImage()
        addCenterItem(isWhite: isWhite)
        self.selectedIndex = 2
        
        changeTabBarToWhite()
        //implementing logic to change TabBar Icons on HOME Child Screen
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabBarToBlack), name: .ChangeTabBarToBlack, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabBarToWhite), name: .ChangeTabBarToWhite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndexToOrders), name: .ChangeIndexToOrders, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndexToHome), name: .ChangeIndexToHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideBottomBarButton), name: .HideBottomBarButton, object: nil)
        tabbar = TabBarSubViewController()
    }
    @objc private func hideBottomBarButton(notification: Notification) {
        if let isHidden = notification.userInfo?["isHidden"] as? Bool {
            if isHidden {
                btnHome.layer.opacity = 0
            } else {
                btnHome.layer.opacity = 1
            }
        }
        
    }
    @objc private func changeIndexToOrders() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedIndex = 0
            self.changeTabBarToWhite()
        }
    }
    @objc private func changeIndexToHome() {
        self.selectedIndex = 2
        changeTabBarToWhite()
    }
    
    @objc private func changeTabBarToBlack() {
        self.tabBar.barTintColor = Color.darkTabbar.color()
        self.tabBar.backgroundColor = Color.darkTabbar.color()
        self.tabBar.isTranslucent = false
        isWhite = false
        let orderBtn = (self.tabBar.items?[0])! as UITabBarItem
        orderBtn.image = UIImage(named: "order-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderBtn.selectedImage = UIImage(named: "order-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderBtn.title = "Orders"
        orderBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let favouriteBtn = (self.tabBar.items?[1])! as UITabBarItem
        favouriteBtn.image = UIImage(named: "favourite-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        favouriteBtn.selectedImage = UIImage(named: "favourite-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        favouriteBtn.title = "Favourites"
        favouriteBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let messageBtn = (self.tabBar.items?[3])! as UITabBarItem
        messageBtn.image = UIImage(named: "message-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        messageBtn.selectedImage = UIImage(named: "message-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        messageBtn.title = "Messages"
        messageBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let profileBtn = (self.tabBar.items?[4])! as UITabBarItem
        profileBtn.image = UIImage(named: "profile-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profileBtn.selectedImage = UIImage(named: "profile-tabbar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profileBtn.title = "Profile"
        profileBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addCenterItem(isWhite: isWhite)
        
    }
    @objc private func changeTabBarToWhite() {
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.init(white: 1, alpha: 1)
        self.tabBar.isTranslucent = false
        isWhite = true
        let orderBtn = (self.tabBar.items?[0])! as UITabBarItem
        orderBtn.image = UIImage(named: "order-tabbar-unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderBtn.selectedImage = UIImage(named: "order-tabbar-selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        orderBtn.title = "Orders"
        orderBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let favouriteBtn = (self.tabBar.items?[1])! as UITabBarItem
        favouriteBtn.image = UIImage(named: "favourite-tabbar-unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        favouriteBtn.selectedImage = UIImage(named: "favourite-tabbar-selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        favouriteBtn.title = "Favourites"
        favouriteBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let messageBtn = (self.tabBar.items?[3])! as UITabBarItem
        messageBtn.image = UIImage(named: "message-tabbar-unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        messageBtn.selectedImage = UIImage(named: "message-tabbar-selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        messageBtn.title = "Messages"
        messageBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let profileBtn = (self.tabBar.items?[4])! as UITabBarItem
        profileBtn.image = UIImage(named: "profile-tabbar-unselected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profileBtn.selectedImage = UIImage(named: "profile-tabbar-selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profileBtn.title = "Profile"
        profileBtn.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addCenterItem(isWhite: isWhite)
        
    }
    
    //    func setupMiddleButton() {
    //
    //        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-35, y: -40, width: 80, height: 80))
    //
    ////        middleBtn.backgroundColor = .white
    //        middleBtn.layer.cornerRadius = middleBtn.frame.height/2
    //
    //
    //        middleBtn.setImage(UIImage(named: "whiteTabCenter"), for: .normal)
    ////        middleBtn.addGradient(color1: Theme.aquaColorDark, color2: Theme.aquaColorLight)
    //
    //        //add to the tabbar and add click event
    //        self.tabBar.addSubview(middleBtn)
    //        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
    //
    //        self.view.layoutIfNeeded()
    //    }
    func addCenterItem(isWhite: Bool) {
        btnHome.layer.masksToBounds = false
        btnHome.layer.shadowOpacity = 0.4
        btnHome.layer.shadowColor = UIColor.gray.cgColor
        btnHome.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnHome.layer.shadowRadius = 5
        
        btnHome.addTarget(self, action: #selector(btnHomeClicked), for: .touchUpInside)
        
        if isWhite {
            btnHome.setImage(UIImage(named: "home-tab-white")!, for: .normal)
            //            btnHome.setBackgroundImage(#imageLiteral(resourceName: "whiteTabCenter").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            btnHome.setImage(UIImage(named: "blackTabCenter")!, for: .normal)
        }
        
        btnHome.translatesAutoresizingMaskIntoConstraints = false
        btnHome.heightAnchor.constraint(equalToConstant: 70).isActive = true
        btnHome.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.addSubview(btnHome)
        
        view.centerXAnchor.constraint(equalTo: btnHome.centerXAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: btnHome.bottomAnchor, constant: tabBar.frame.size.height - 37).isActive = true
    }
    
    @objc func btnHomeClicked() {
        self.selectedIndex = 2
        if let count = (self.children[2] as? UINavigationController)?.children {
            if count.first is HomeScreenViewController {
                Utilities.topMostController().navigationController?.popToRootViewController(animated: true)
            }
            for controller in count {
                if controller is SearchViewController {
                    let vc = Storyboard.tabbar.instantiate(identifier: TabBarViewController.self)
                    UIApplication.shared.setRoot(vc: vc)
                    break
                }
            }
        }
        if let count = (self.children[2] as? UINavigationController)?.children.count {
            if count > 1 {
                NotificationCenter.default.post(name: .ChangeTabBarToBlack, object: self)
            } else {
                NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is UINavigationController {
            if let _ = viewController.children[0] as? OrdersViewController {
                NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
                return true
            }
            if let _ = viewController.children[0] as? FavoritesViewController {
                NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
                return true
            }
            if let _ = viewController.children[0] as? MessagesViewController {
                NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
                return true
            }
            if let _ = viewController.children[0] as? ProfileViewController {
                NotificationCenter.default.post(name: .ChangeTabBarToWhite, object: nil)
                return true
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is UINavigationController {
            if let _ = viewController.children[0] as? OrdersViewController {
                discardGuestUserSession()
            }
            
            if let _ = viewController.children[0] as? FavoritesViewController {
                discardGuestUserSession()
            }
            
            if let _ = viewController.children[0] as? MessagesViewController {
                discardGuestUserSession()
            }
            
            if let _ = viewController.children[0] as? ProfileViewController {
                discardGuestUserSession()
            }
        }
    }
    
    fileprivate func discardGuestUserSession() {
        if let appDelegate = AppDelegate.appDelegateInstance {
            appDelegate.isGuestModeEnabled ? (Coordinator.LoginScreen()) : ()
        }
    }
}

@IBDesignable
class TabBarSubViewController : UITabBar {
    
    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        if isWhite {
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
        } else {
            shapeLayer.strokeColor = Color.darkTabbar.color().cgColor
            shapeLayer.fillColor = Color.darkTabbar.color().cgColor
            shapeLayer.lineWidth = 1.0
            
        }
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    func createPath() -> CGPath {
        
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    func createPathCircle() -> CGPath {
        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
