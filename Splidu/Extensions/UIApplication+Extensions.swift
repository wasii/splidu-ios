//
//  UIApplication+Extensions.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import Foundation
import UIKit

extension UIApplication {
    var keywindow: UIWindow? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window
    }
    
    func setRoot(vc: UIViewController) {
        keywindow?.rootViewController = vc
    }
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
