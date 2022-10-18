//
//  Storyboard.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import Foundation
import UIKit


enum Storyboard: String {
    case authentication     = "Authentication"
    case alert              = "Alerts"
    case sidemenu           = "SideMenu"
    case home               = "Home"
    case orders             = "Orders"
    case favorites          = "Favorites"
    case messages           = "Messages"
    case profile            = "Profile"
    case tabbar             = "Tabbar"
    case search             = "SearchFilter"
    
    func instantiate<T>(identifier: T.Type) -> T {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        guard let viewcontroller = storyboard.instantiateViewController(withIdentifier: String(describing: identifier)) as? T else {
            fatalError("No such view controller found")
        }
        return viewcontroller
    }
}
