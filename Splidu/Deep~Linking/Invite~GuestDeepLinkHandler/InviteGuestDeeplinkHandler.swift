//
//  InviteGuestDeeplinkHandler.swift
//  Splidu
//
//  Created by Muneeb on 27/09/2022.
//

import Foundation
import UIKit

final class InviteDeeplinkHandler: DeeplinkHandlerProtocol {
    private weak var rootViewController: UIViewController?
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - DeeplinkHandler Protocol
    func canOpenURL(_ url: URL) -> Bool {
        return url.absoluteString.hasPrefix(DeepLinkConst.inviteGuestURL)
    }
    
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            // if unable to open the link then go to appstore connect
            print("Unable to open link")
            return
        }
        
        print(url.path)
        if let _ = UserDefaults.standard.string(forKey: ud_user_token) {
            Coordinator.showDietaryScreen(viewController: rootViewController, allDiet: [], diet: [], allergens: [], userIndex: 0, is_accept: "")
        }
    }
}
