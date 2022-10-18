//
//  AppConfiguration.swift
//
//  Created by Muneeb on 23/05/2022.
//

import Foundation
import UIKit
struct AppConfiguration {}

// MARK: - Custom Configurations
extension AppConfiguration {
    static  func canOpenSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
}
