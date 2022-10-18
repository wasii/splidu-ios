//
//  ShareSheet.swift
//  Splidu
//
//  Created by Muneeb on 30/09/2022.
//

import Foundation
import UIKit

class ShareSheet {
    
    static func openShareSheet(rootController: UIViewController, chefID: String) {
        let description = """
        "Hey there! Lets Dine...
        Inviting you for an event which is on "date time" at "location". Fill your dietary restrictions for the meal by clicking on below link.
        """
        let deepLinkURL : NSURL = NSURL(string: "\(DeepLinkConst.inviteGuestURL)?chefID=\(chefID)")!
        let activityViewController = UIActivityViewController(activityItems: [description, deepLinkURL] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = rootController.view
        rootController.present(activityViewController, animated: true, completion: nil)
    }
}
