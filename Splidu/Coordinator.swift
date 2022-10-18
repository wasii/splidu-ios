//
//  Coordinator.swift
//  Splidu
//
//  Created by abdWasiq on 26/08/2022.
//

import UIKit
//import SideMenuSwift

struct Coordinator {
    //MARK: Authentication Functions...
    static func LoginScreen() {
        let vc = Storyboard.authentication.instantiate(identifier: LoginScreenViewController.self)
        let navVc = UINavigationController.init(rootViewController: vc)
        UIApplication.shared.setRoot(vc: navVc)
    }
    static func showIntroOneVC() {
        let vc = Storyboard.authentication.instantiate(identifier: IntroAppViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        UIApplication.shared.setRoot(vc: navVC)
    }
    
    static func showFaceIdPopup(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: UnlockWithFaceIdViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showSignUpScreen(delegate: UIViewController?) {
        let vc = Storyboard.authentication.instantiate(identifier: SignupViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showForgotPassword(delegate: UIViewController?) {
        let vc = Storyboard.authentication.instantiate(identifier: ForgotPasswordViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(vc, animated: false)
    }
    
    static func showOTPScreen(delegate: UIViewController?, registerNewUser: NewUserRegistration? = nil, verifyForgotPassword: ForgotPasswordVerificationType? = nil, verifyMobileOTP: VerifyMobileOTP? = nil) {
        let vc = Storyboard.authentication.instantiate(identifier: OTPViewController.self)
        vc.newRegisteredUser = registerNewUser
        vc.verifyForgotPassword = verifyForgotPassword
        vc.verifyMobileOTP = verifyMobileOTP
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    
    static func shoeMobileOTP(delegate: UIViewController?, socialID: String) {
        let VC = Storyboard.authentication.instantiate(identifier: MobileOTPVC.self)
        VC.socialID = socialID
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    
    static func profileCreatedScreen(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: ProfileCreatedViewController.self)
        let navVc = UINavigationController.init(rootViewController: vc)
        navVc.modalPresentationStyle = .overFullScreen
        navVc.modalTransitionStyle = .crossDissolve
        delegate?.present(navVc, animated: true, completion: nil)
    }
    
    static func showLetsExploreScreen(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: LetsExploreViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    /*
        Authentication End
     */
    
    static func gotoTabBar() {
        let vc = Storyboard.tabbar.instantiate(identifier: TabBarViewController.self)
        UIApplication.shared.setRoot(vc: vc)
    }
    
    //MARK: HOME SCREEN
    static func showHomeCategoryScreen(delegate: UIViewController?, mainHeading: String) {
        let VC = Storyboard.home.instantiate(identifier: HomeCategoryViewController.self)
        VC.mainHeading = mainHeading
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func showHomeCategoryChefs(delegate: UIViewController?, chefId: Int?, chefName: String?) {
        let VC = Storyboard.home.instantiate(identifier: HomeCategoryChefViewController.self)
        VC.pageTitle = chefName ?? ""
        VC.chefId = chefId
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showHomeCategoryChefsDetail(delegate: UIViewController?, chefId: Int?, chefName: String?) {
        let VC = Storyboard.home.instantiate(identifier: HomeChefDetailViewController.self)
        VC.chefId = chefId
        VC.pageTitle = chefName!
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showBookingExperience(delegate: UIViewController?, chef_detail: HomeChefDetailModel?) {
        let VC = Storyboard.home.instantiate(identifier: BookYourExperienceViewController.self)
        VC.chef_detail = chef_detail
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func showSeatSelectionAlert(controller: UIViewController?, delegate: UpdateWaitingList) {
        let vc = Storyboard.alert.instantiate(identifier: SeatSelectionAlertViewController.self)
        vc.delegate = delegate
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        controller?.present(navVC, animated: true, completion: nil)
    }
    static func showMonthSelectionAlert(vc: UIViewController?, month_data: [MonthSelection]?, delegate: MonthSelectionDelegate) {
        let VC = Storyboard.alert.instantiate(identifier: MonthSelectionViewController.self)
        VC.month_data = month_data
        VC.delegate = delegate
        let navVC = UINavigationController.init(rootViewController: VC)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        vc?.present(navVC, animated: true, completion: nil)
    }
    static func showBookingConfirmAlert(delegate: UIViewController?, orderNumber: String, navDelegate: NavigateToInviteGuest) {
        let vc = Storyboard.alert.instantiate(identifier: BookingConfirmAlertViewController.self)
        vc.orderNumber = orderNumber
        vc.navDelegate = navDelegate
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showAddGuestDetails(delegate: UIViewController?, numberOfSeats: String, order_number: String, chefId: Int) {
        let VC = Storyboard.home.instantiate(identifier: AddGuestDetailsViewController.self)
        VC.numberOfSeats = numberOfSeats
        VC.order_number = order_number
        VC.chefId = chefId
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func showDietaryScreen(viewController: UIViewController?, allDiet: [BookingAttributesDetails]?, diet: [BookingAttributesDetails]?, allergens: [BookingAttributesDetails]?, userIndex: Int?, is_accept: String?) {
        let VC = Storyboard.home.instantiate(identifier: DietaryRestrictionsViewController.self)
        VC.allDietary = allDiet
        VC.dietary = diet
        VC.allergens = allergens
        VC.userIndex = userIndex
        VC.isAccept = is_accept ?? ""
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        if let _ = viewController?.navigationController {
            viewController?.navigationController?.view.layer.add(transition, forKey: kCATransition)
            viewController?.navigationController?.pushViewController(VC, animated: false)
        } else {
            viewController?.present(VC, animated: true)
        }
    }
    
   
    static func showOrderSuccessPopup(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: OrderSuccessViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showNotificationScreen(delegate: UIViewController?) {
        let VC = Storyboard.home.instantiate(identifier: NotificationsViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    /*
     HomeScreen
     */
    
    //MARK: Orders Screen
    static func showOrderRating(delegate: UIViewController?) {
        let VC = Storyboard.orders.instantiate(identifier: OrderRatingViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showEventDetails(delegate: UIViewController?, orderId: String) {
        let VC = Storyboard.orders.instantiate(identifier: EventDetailsViewController.self)
        VC.orderId = orderId
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func showEventDetailsPopup(delegate: UIViewController?, order_detail: OrderDetailModel?) {
//        OrderCancelViewController
        let vc = Storyboard.alert.instantiate(identifier: EventDetailsPopupViewController.self)
        vc.order_detail = order_detail
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showConfirmAllBookingCancel(delegate: UIViewController?, duduction: String) {
        let vc = Storyboard.alert.instantiate(identifier: CancelAllBookingViewController.self)
        vc.deduction = duduction
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showAllBookingCancelledSuccessPopup(delegate: UIViewController?, message: String) {
        let vc = Storyboard.alert.instantiate(identifier: AllBookingCancelledSuccessPopupViewController.self)
        vc.message = message
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showConfirmSingleBookingCancel(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: CancelSingleBookingPopupViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    static func showSingleBookingCancelledSuccessPopup(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: SingleBookingCancelledPopupViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        delegate?.present(navVC, animated: true, completion: nil)
    }
    /*
     Orders
     */
    
    
    //MARK: SideMenu
    static func showOurStory(delegate: UIViewController?) {
        let VC = Storyboard.sidemenu.instantiate(identifier: OurStoryViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func showTermConditions(delegate: UIViewController?) {
        let VC = Storyboard.sidemenu.instantiate(identifier: TermsConditionViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showPrivacyPolicy(delegate: UIViewController?) {
        let VC = Storyboard.sidemenu.instantiate(identifier: PrivacyPolicyViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showHelp(delegate: UIViewController?) {
        let VC = Storyboard.sidemenu.instantiate(identifier: HelpViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showFAQs(delegate: UIViewController?) {
        let VC = Storyboard.sidemenu.instantiate(identifier: FAQsViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    /*
     SideMenu
     */
    
    
    //MARK: Search
    static func showSearchScreen(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: SearchViewController.self)
//        let navVc = UINavigationController.init(rootViewController: VC)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: true)
//        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchFilterMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: FilterViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchDateMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: DateViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchDietaryMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: DietaryViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchCusisineMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: CuisineViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchLocationMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: LocationViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchOfferMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: OfferViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    static func showSearchRatingMenu(delegate: UIViewController?) {
        let VC = Storyboard.search.instantiate(identifier: RatingViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    /*
     Search
     */
    static func conversation(delegate: UIViewController?){
        let vc = Storyboard.messages.instantiate(identifier: ConversationViewController.self)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        delegate?.present(navVC, animated: true, completion: nil)
    }
    
    
    static func showMyLocation(delegate: UIViewController?) {
        let VC = Storyboard.profile.instantiate(identifier: MyLocationViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func AddNewLocation(delegate: UIViewController?, callLocationDelegate: CallLocation, location: LocationData?) {
        let vc = Storyboard.alert.instantiate(identifier: AddNewLocationViewController.self)
        vc.delegate = callLocationDelegate
        vc.locationData = location
        let navVc = UINavigationController.init(rootViewController: vc)
        navVc.modalPresentationStyle = .overFullScreen
        navVc.modalTransitionStyle = .crossDissolve
        delegate?.present(navVc, animated: true, completion: nil)
    }
    
    static func logout(delegate: UIViewController?) {
        let vc = Storyboard.alert.instantiate(identifier: LogoutViewController.self)
        let navVc = UINavigationController.init(rootViewController: vc)
        navVc.modalPresentationStyle = .overFullScreen
        navVc.modalTransitionStyle = .crossDissolve
        delegate?.present(navVc, animated: true, completion: nil)
    }
    
    static func dismissPopUp(delegate: UIViewController?){
        delegate?.dismiss(animated: true)
    }
    
    
    static func changePassword(delegate: UIViewController?, verifyForgotPasswordPassword: ForgotPasswordVerificationType? = nil){
        let VC = Storyboard.profile.instantiate(identifier: ChangePasswordViewController.self)
        VC.verifyForgotPassword = verifyForgotPasswordPassword
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func wallet(delegate: UIViewController?){
        let VC = Storyboard.profile.instantiate(identifier: WalletViewController.self)
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func updateProfile(delegate: UIViewController?, profile: MyProfileModel?){
        let vc = Storyboard.profile.instantiate(identifier: UpdateProfileViewController.self)
        vc.profile = profile
        let navVc = UINavigationController.init(rootViewController: vc)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
//        delegate?.present(navVc, animated: true, completion: nil)
        delegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openMyOrders(delegate: UIViewController?) {
        let vc = Storyboard.orders.instantiate(identifier: OrdersViewController.self)
        vc.isFromProfile = true
        let transition = CATransition()
        transition.duration = 0.30
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(vc, animated: false)
    }
}
