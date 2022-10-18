//
//  BaseViewController.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit
import SideMenu

enum ViewControllerType {
    case authentication
    case home
    case backWhite
    case backBlack
    case backWithThreeButtons
    case backWithSigleButton
    case orders
    case messages
    case searchFilter
    case notifications
}
class BaseViewController: UIViewController {

    var type: ViewControllerType = .authentication
    var titleLabel: UILabel?
    
    
    var viewControllerTitle: String? {
        didSet {
            titleLabel?.text = viewControllerTitle ?? ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        solidNavigationBar()
        switch type {
        case .authentication: break
        case .home:
            setHomeScreen()
        case .backWhite:
            setBackWhiteWithNoButtons()
        case .backBlack:
            setBackBlackWithNoButtons()
        case .backWithThreeButtons:
            setWhiteBackWithButtons()
        case .backWithSigleButton:
            setWhiteBackWithSingleButton()
        case .orders:
            setOrderScreen()
        case .messages:
            setMessagesScreen()
        case .searchFilter:
            setSearchFilterScreen()
        case .notifications:
            setNotificationScreen()
        }
    }
    private func solidNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }else{
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = .clear
        }
    }
    func setStroke(string:String) -> NSMutableAttributedString {
        let attributeString =  NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    func discardGuestUserSession() {
        if let appDelegate = AppDelegate.appDelegateInstance {
            appDelegate.isGuestModeEnabled ? (Coordinator.LoginScreen()) : ()
        }
    }
    
    func setHomeScreen() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setHomeScreenNavBar()
        setHomeScreenTitleImage()
        addSideMenu()
    }
    func setMessagesScreen() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setMessageNavBar()
    }
    func setSearchFilterScreen() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setSearchFilterNavBar()
        addBackButton()
        addTitleLabel()
        
    }
    func setNotificationScreen() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setNotificationNavBar()
        addBackButton()
        addTitleLabel()
        
    }
    func setOrderScreen() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setOrderNavBar()
    }
    fileprivate func setBackBlackWithNoButtons() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
    }
    fileprivate func setBackWhiteWithNoButtons() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addWhiteBackButton()
        addWhiteTitleLabel()
    }
    fileprivate func setBackWithButton() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setHomeScreenNavBar()
        addBackButton()
        addTitleLabel()
    }
    fileprivate func setWhiteBackWithButtons() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        setHomeScreenNavBarWhite()
        addWhiteBackButton()
        addWhiteTitleLabel()
    }
    fileprivate func setWhiteBackWithSingleButton() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        
        addWhiteBackButton()
        addWhiteTitleLabel()
        addSingleWhiteButton()
    }
    private func addSingleWhiteButton() {
        let search = UIButton()
        search.setImage(UIImage(named: "Vector1"), for: .normal)
//        search.addTarget(self, action: #selector(searchtapped), for: .touchUpInside)
        let searchBtn = UIBarButtonItem(customView: search)
        
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    private func addSideMenu() {
        let btn = UIButton()
        btn.setImage(UIImage(named: "hamburgericon"), for: .normal)
        btn.addTarget(self, action: #selector(openSideMenu(_:)), for: .touchUpInside)
        let bbi = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = bbi
    }
    @objc func openSideMenu(_ button : UIButton){
        let vc = Storyboard.sidemenu.instantiate(identifier: SidemenuViewController.self)
        let leftMenu = SideMenuNavigationController(rootViewController: vc)
        
        leftMenu.leftSide = true
        leftMenu.presentationStyle = .menuSlideIn
        leftMenu.statusBarEndAlpha = 0
        leftMenu.menuWidth = UIScreen.main.bounds.width * 0.8
//        SideMenuManager.default.
//        SideMenuManager.default.leftMenuNavigationController = leftMenu
        self.topMostController().present(leftMenu, animated: true)
    }
    private func setHomeScreenNavBar() {
        let search = UIButton()
        search.setImage(UIImage(named: "search-icon-navbar"), for: .normal)
        search.addTarget(self, action: #selector(searchtapped), for: .touchUpInside)
        let searchBtn = UIBarButtonItem(customView: search)
        
        let bell = UIButton()
        bell.setImage(UIImage(named: "bell-icon-navbar"), for: .normal)
        bell.addTarget(self, action: #selector(belltapped), for: .touchUpInside)
        let bellBtn = UIBarButtonItem(customView: bell)
        
        let token = UIButton()
        token.setImage(UIImage(named: "token-icon-navbar"), for: .normal)
        token.addTarget(self, action: #selector(tokentapped), for: .touchUpInside)
        let tokenBtn = UIBarButtonItem(customView: token)
        
        
        self.navigationItem.rightBarButtonItems = [tokenBtn,bellBtn,searchBtn]
    }
    private func setHomeScreenNavBarWhite() {
        let search = UIButton()
        search.setImage(UIImage(named: "search-white"), for: .normal)
        search.addTarget(self, action: #selector(searchtapped), for: .touchUpInside)
        let searchBtn = UIBarButtonItem(customView: search)
        
        let bell = UIButton()
        bell.setImage(UIImage(named: "bell-white"), for: .normal)
        bell.addTarget(self, action: #selector(belltapped), for: .touchUpInside)
        let bellBtn = UIBarButtonItem(customView: bell)
        
        let token = UIButton()
        token.setImage(UIImage(named: "token-black"), for: .normal)
        token.addTarget(self, action: #selector(tokentapped), for: .touchUpInside)
        let tokenBtn = UIBarButtonItem(customView: token)
        
        
        self.navigationItem.rightBarButtonItems = [tokenBtn,bellBtn,searchBtn]
    }
    private func setHomeScreenTitleImage() {
        let logo = UIImage(named: "image 5.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    func addTitleLabel() {
        titleLabel = UILabel()
        if let titleLabel = titleLabel {
            titleLabel.text = viewControllerTitle ?? ""
            titleLabel.font = UIFont(name: "Nunito-SemiBold", size: 17)
            titleLabel.textColor = UIColor.black
            let stack = UIStackView(arrangedSubviews: [titleLabel])
            let barButton = UIBarButtonItem(customView: stack)
            navigationItem.leftBarButtonItems?.append(barButton)
            
        }
    }
    func addWhiteTitleLabel() {
        titleLabel = UILabel()
        if let titleLabel = titleLabel {
            titleLabel.text = viewControllerTitle ?? ""
            titleLabel.font = UIFont(name: "Nunito-SemiBold", size: 17)
            titleLabel.textColor = UIColor.white
            let stack = UIStackView(arrangedSubviews: [titleLabel])
            let barButton = UIBarButtonItem(customView: stack)
            navigationItem.leftBarButtonItems?.append(barButton)
            
        }
    }
    func addBackButton() {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back_black_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: backButton))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    func addWhiteBackButton() {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-white"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: backButton))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    @objc func backButtonAction() {
        
        if let _ = navigationController?.popViewController(animated: true) {
            
        } else {
            navigationController?.tabBarController?.selectedIndex = 0
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc func searchtapped() {
        NotificationCenter.default.post(name: .ChangeTabBarToBlack, object: nil)
        Coordinator.showSearchScreen(delegate: self)
    }
    @objc func belltapped() {
        Coordinator.showNotificationScreen(delegate: self)
    }
    @objc func tokentapped() {
        Coordinator.wallet(delegate: self)
    }
    private func setOrderNavBar() {
        let search = UIButton()
        search.setImage(UIImage(named: "search-icon-navbar"), for: .normal)
        search.addTarget(self, action: #selector(searchtapped), for: .touchUpInside)
        let searchBtn = UIBarButtonItem(customView: search)
        
        let bell = UIButton()
        bell.setImage(UIImage(named: "bell-icon-navbar"), for: .normal)
        bell.addTarget(self, action: #selector(belltapped), for: .touchUpInside)
        let bellBtn = UIBarButtonItem(customView: bell)
        
        self.navigationItem.rightBarButtonItems = [bellBtn,searchBtn]
    }
    private func setMessageNavBar() {
        let search = UIButton()
        search.setImage(UIImage(named: "search-icon-navbar"), for: .normal)
        search.addTarget(self, action: #selector(searchtapped), for: .touchUpInside)
        let searchBtn = UIBarButtonItem(customView: search)
        
        let bell = UIButton()
        bell.setImage(UIImage(named: "bell-icon-navbar"), for: .normal)
        bell.addTarget(self, action: #selector(belltapped), for: .touchUpInside)
        let bellBtn = UIBarButtonItem(customView: bell)
        
        self.navigationItem.rightBarButtonItems = [bellBtn,searchBtn]
    }
    private func setSearchFilterNavBar() {
        let clearAll = UIButton()
        clearAll.setImage(UIImage(named: "ClearAll"), for: .normal)
        let clearAllBtn = UIBarButtonItem(customView: clearAll)
        
        self.navigationItem.rightBarButtonItem = clearAllBtn
    }
    private func setNotificationNavBar() {
        let clearAll = UIButton()
        clearAll.setImage(UIImage(named: "clear all"), for: .normal)
        let clearAllBtn = UIBarButtonItem(customView: clearAll)
        
        self.navigationItem.rightBarButtonItem = clearAllBtn
    }
    
    
    
    
    
    func topMostController() -> UIViewController {
        var topController : UIViewController?
        if #available(iOS 13.0, *) {
            topController = UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController
        } else {
            topController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        topController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if (topController?.isKind(of: UITabBarController.self))! {
            let tab = topController as! UITabBarController
            topController = tab.viewControllers![tab.selectedIndex]
        }
        
        if (topController?.isKind(of: UINavigationController.self))! {
            let navigation = topController as! UINavigationController
            topController = navigation.visibleViewController
        }
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
            if (topController?.isKind(of: UITabBarController.self))! {
                let tab = topController as! UITabBarController
                topController = tab.viewControllers![tab.selectedIndex]
            }
            
            if (topController?.isKind(of: UINavigationController.self))! {
                let navigation = topController as! UINavigationController
                topController = navigation.visibleViewController
            }
        }
        
        return topController!
    }
}
