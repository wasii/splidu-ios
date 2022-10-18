//
//  Colors.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import Foundation
import UIKit

enum Color: String, CaseIterable {
    case customPurple   = "purple"
    case pinkPurple     = "pinkPurple"
    case customPink     = "customPink"
    case childViewColor = "childViewColor"
    case aquaGreen      = "customAquaGreen"
    case customBlack    = "customBlack"
    case buttonColor    = "customButtonColor"
    case darkGray       = "darkGray"
    case darkTeal       = "darkTeal"
    case underlineColor = "underlineColor"
    case darkPurple     = "darkPurple"
    case selectedColor  = "optionSelectedColor"
    case filledSlot     = "filledSlot"
    case darkTabbar     = "darkTabbar"
    func color() -> UIColor {
        guard let color = UIColor(named: rawValue) else {
            fatalError("No such color found")
        }
        return color
    }
}
