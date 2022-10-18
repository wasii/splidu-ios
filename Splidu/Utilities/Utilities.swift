//
//  Utilities.swift
//  Splidu
//
//  Created by abdWasiq on 12/09/2022.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Utilities {
    static var activityIndicatorView: NVActivityIndicatorView!
    static var coverView: UIView!
    
    public class func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    public class func getTheExtension(mimeType:String) -> String {
         switch mimeType {
         case "image/jpeg":
             return ".jpg"
         case "image/png":
             return ".png"
         case "image/gif":
             return ".gif"
         case "image/tiff":
             return ".tiff"
         case "application/pdf":
             return ".pdf"
         case "application/vnd":
             return ".xls"
         case "text/plain","application/octet-stream":
             return ".txt"
         case "application/msword":
             return ".doc"
         case "application/powerpoint":
             return ".ppt"
         case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
             return ".pptx"
         case "application/vnd.openxmlformats-officedocument.presentationml.slideshow":
             return ".ppsx"
         default:
             return ""
         }
     }
    
    public class func showIndicatorView() {
        if activityIndicatorView != nil {
            activityIndicatorView.removeFromSuperview()
            coverView.removeFromSuperview()
        }
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: Color.customPink.color(), padding: 2.0)
        coverView = UIView(frame: keyWindow.frame)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        coverView.addSubview(activityIndicatorView)
        activityIndicatorView.center = coverView.center
        keyWindow.addSubview(coverView)
        activityIndicatorView.startAnimating()
    }
    
    public class func hideIndicatorView() {
        DispatchQueue.main.async {
            if activityIndicatorView != nil {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                coverView.removeFromSuperview()
                activityIndicatorView = nil
                coverView = nil
            }
        }
    }
    
    class func showSuccessAlert(message: String, okayHandler: (()->())? = nil) {
        generateSuccessFeedback()
        let alertView = AlertPopUp.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }
    
    class func showWarningAlert(message: String, okayHandler: (()->())? = nil) {
        generateWarningFeedback()
        let alertView = AlertPopUp.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }
    
    
    class func generateSuccessFeedback() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
    }
    
    class func generateWarningFeedback() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.warning)
    }
    
    class func discardGuestUserSession() {
        if let appDelegate = AppDelegate.appDelegateInstance {
            appDelegate.isGuestModeEnabled ? (Coordinator.LoginScreen()) : ()
        }
    }
    
    class func topMostController() -> UIViewController {
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
    class func shareToOthers(shareText: String, sender:UIButton, delegate: UIViewController) {
        
        // set up activity view controller
        let textToShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = delegate.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        delegate.present(activityViewController, animated: true, completion: nil)
        return
    }
}
