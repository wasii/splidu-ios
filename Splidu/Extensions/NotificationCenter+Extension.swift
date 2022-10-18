//
//  NotificationCenter+Extension.swift
//  Splidu
//
//  Created by abdWasiq on 02/09/2022.
//

import Foundation


extension Notification.Name {
    //Tabbar Notifications
    static let HideBottomBarButton = Notification.Name.init("HideBottomBarButton")
    static let ChangeTabBarToBlack = Notification.Name.init("changeTabBarToBlack")
    static let ChangeTabBarToWhite = Notification.Name.init("changeTabBarToWhite")
    static let ChangeIndexToOrders = Notification.Name.init("ChangeIndexToOrders")
    static let ChangeIndexToHome = Notification.Name.init("ChangeIndexToHome")
    
    //Home Notifications
    static let CompleteOrder = Notification.Name.init(rawValue: "CompleteOrder")
    
    //Orders Notifications
    static let UpcomingOrders = Notification.Name.init(rawValue: "UpcomingOrders")
    static let CompletedOrders = Notification.Name.init(rawValue: "CompletedOrders")
    static let CancelledOrders = Notification.Name.init(rawValue: "CancelledOrders")
    
    static let CancelSingleBooking = Notification.Name.init(rawValue: "cancelSingleBooking")
    static let CancelAllBooking = Notification.Name.init(rawValue: "cancelAllBooking")
    
    static let ConfirmAllBookingCancel = Notification.Name.init(rawValue: "confirmAllBookingCancel")
    static let ConfirmSingleBookingCancel = Notification.Name.init(rawValue: "confirmSingleBookingCancel")
    
    static let ShowAllBookingCancelSuccessPopup = Notification.Name.init(rawValue: "ShowAllBookingCancelSuccessPopup")
    static let ShowSingleBookingCancelSuccessPopup = Notification.Name.init(rawValue: "ShowSingleBookingCancelSuccessPopup")
    
    static let ExploreAllBookingCancelled = Notification.Name.init(rawValue: "ExploreAllBookingCancelled")
    
    static let RefreshEventDetails = Notification.Name.init(rawValue: "RefreshEventDetails")
    
    //Favourite Notifications
    static let FetchNewFavourites = Notification.Name.init(rawValue: "FetchNewFavourites")
}
