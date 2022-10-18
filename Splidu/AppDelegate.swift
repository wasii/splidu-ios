//
//  AppDelegate.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit
import SideMenu
import IQKeyboardManagerSwift
import FacebookCore
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isGuestModeEnabled: Bool = false
    
    static weak var appDelegateInstance: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }
    
    var deeplinkCoordinator: DeeplinkCoordinatorProtocol {
        return DeeplinkCoordinator(handlers: [
            InviteDeeplinkHandler(rootViewController: self.rootViewController)
        ])
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        addCustomDelay()
        initializeStripePaymentGateway()
        setRootVC()
        window?.makeKeyAndVisible()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        print(url.absoluteString)
        return deeplinkCoordinator.handleURL(url)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : .all
    }
    
    fileprivate func addCustomDelay() {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 3.0))
    }
    
    fileprivate func isIntroScreenLaunched() -> Bool {
        var isAppLaunched = false
        if let isIntro_Launched: Bool = UserDefaults.standard.object(forKey: UserDefaults.AppUserDefault.isAppIntroduced) as? Bool {
            isAppLaunched = isIntro_Launched
        }
        return isAppLaunched
    }
}

extension AppDelegate {
    fileprivate func setRootVC() {
        if let isUserLoggedIn: Bool = UserDefaults.standard.object(forKey: UserDefaults.AppUserDefault.isRemeberLoginUser) as? Bool {
            isUserLoggedIn ? (Coordinator.gotoTabBar()) : (isIntroScreenLaunched() ? (Coordinator.LoginScreen()) : (Coordinator.showIntroOneVC()))
        } else {
            isIntroScreenLaunched() ? (Coordinator.LoginScreen()) : (Coordinator.showIntroOneVC())
        }
    }
}

// MARK: - Initialize Stripe
extension AppDelegate {
    fileprivate func initializeStripePaymentGateway() {
        STPAPIClient.shared.publishableKey = Constants.stripeKey
        STPPaymentConfiguration.shared.publishableKey = Constants.stripeKey
    }
}
