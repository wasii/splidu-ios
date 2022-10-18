//
//  UpdateProfileViewController.swift
//  Splidu
//
//  Created by Rafi on 05/09/2022.
//

import UIKit
import TagListView
import AVFoundation
import Photos

protocol ImagePickerDelegate: class {
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType)
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    func cancelButtonDidClick(on imageView: ImagePicker)
}

class ImagePicker: NSObject {

    private weak var controller: UIImagePickerController?
    weak var delegate: ImagePickerDelegate? = nil

    func dismiss() { controller?.dismiss(animated: true, completion: nil) }
    func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        self.controller = controller
        DispatchQueue.main.async {
            viewController.present(controller, animated: true, completion: nil)
        }
    }
}
extension ImagePicker {

    private func showAlert(targetName: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: "Access to the \(targetName)",
                                            message: "Please provide access to your \(targetName)",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(settingsUrl) else { completion?(false); return }
                UIApplication.shared.open(settingsUrl, options: [:]) { [weak self] _ in
                    self?.showAlert(targetName: targetName, completion: completion)
                }
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion?(false) }))
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?
                .rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }

    func cameraAsscessRequest() {
        if delegate == nil { return }
        let source = UIImagePickerController.SourceType.camera
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            delegate?.imagePicker(self, grantedAccess: true, to: source)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.delegate?.imagePicker(self, grantedAccess: granted, to: source)
                } else {
                    self.showAlert(targetName: "camera") { self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
                }
            }
        }
    }

    func photoGalleryAsscessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            let source = UIImagePickerController.SourceType.photoLibrary
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.imagePicker(self, grantedAccess: result == .authorized, to: source)
                }
            } else {
                self.showAlert(targetName: "photo gallery") { self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
            }
        }
    }
}
// MARK: UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate { }

// MARK: UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
            return
        }

        if let image = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
        } else {
            print("Other source")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancelButtonDidClick(on: self)
    }
}
class UpdateProfileViewController: BaseViewController {
    //error outlet
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var firstnameErr: UILabel!
    @IBOutlet weak var lastnameErr: UILabel!
    @IBOutlet weak var emailErr: UILabel!
    @IBOutlet weak var dobErr: UILabel!
    
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var firstNameTextField: UnderLineImageTextField!
    @IBOutlet weak var lastNameTextField: UnderLineImageTextField!
    @IBOutlet weak var preferredNameTextField: UnderLineImageTextField!
    @IBOutlet weak var emailAddressTextField: UnderLineImageTextField!
    @IBOutlet weak var dobTextField: UnderLineImageTextField!
    
    
    @IBOutlet weak var interestTextField: UnderLineImageTextField!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var interestHeight: NSLayoutConstraint!
    
    @IBOutlet weak var allergensTextField: UnderLineImageTextField!
    @IBOutlet weak var allergensCollectionView: UICollectionView!
    @IBOutlet weak var allergensHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dietaryTextField: UnderLineImageTextField!
    @IBOutlet weak var dietaryCollectionView: UICollectionView!
    @IBOutlet weak var dietaryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dislikeTextField: UnderLineImageTextField!
    @IBOutlet weak var dislikeCollectionView: UICollectionView!
    @IBOutlet weak var dislikeHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var linkedInTextField: UITextField!
    
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var discloseView: UIView!
    
    
    @IBOutlet weak var femaleGradient: UIImageView!
    @IBOutlet weak var maleGradient: UIImageView!
    @IBOutlet weak var discloseGradient: UIImageView!
    
    
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var discloseBtn: UIButton!
    
    var interests, allergens, dietaries, dislikes: [BookingAttributesDetails]?
    var tInterests, tAllergens, tDietaries, tDislikes: [BookingAttributesDetails]?
    
    var gender = ""
    var profile: MyProfileModel?
    private weak var imageView: UIImageView!
        private lazy var imagePicker: ImagePicker = {
            let imagePicker = ImagePicker()
            imagePicker.delegate = self
            return imagePicker
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        getBookingAttribute()
        type = .backBlack
        viewControllerTitle = "Edit Profile"
        setupInterface()
        
        interestTextField.delegate = self
        allergensTextField.delegate = self
        dietaryTextField.delegate = self
        dislikeTextField.delegate = self
        dobTextField.delegate = self
        
        if let profile = profile {
            let url = URL(string: (profile.base_url ?? "") + (profile.user?.userImage ?? ""))
            self.userProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "Default-Image"))
            self.firstNameTextField.text = profile.user?.firstName ?? ""
            self.lastNameTextField.text = profile.user?.lastName ?? ""
            self.preferredNameTextField.text = profile.user?.name ?? ""
            if let dob = profile.user?.dateOfBirth?.split(separator: " ").first {
//                let d = String(dob.split(separator: " ").first)// dob.split(separator: " ").first
//                self.dobTextField.text = "\(d)"
                self.dobTextField.text = "\(dob)"
            }
            
            self.emailAddressTextField.text = profile.user?.email ?? ""
            
            self.femaleGradient.isHidden = true
            self.maleGradient.isHidden = true
            self.discloseGradient.isHidden = true
            
            self.femaleView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
            self.maleView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
            self.discloseView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
            
            switch profile.user?.gender {
            case "Male":
                gender = "Male"
                self.maleGradient.isHidden = false
                break
            case "Female":
                gender = "Female"
                self.femaleGradient.isHidden = false
                break
            case nil, "":
                gender = ""
                self.discloseGradient.isHidden = false
                break
            default: break
            }
            
            self.facebookTextField.text = profile.user?.fbLink ?? ""
            self.linkedInTextField.text = profile.user?.liLink ?? ""
            self.instagramTextField.text = profile.user?.inLink ?? ""
            self.twitterTextField.text = profile.user?.twLink ?? ""
            
            if let all = profile.allergens {
                tAllergens = [BookingAttributesDetails]()
                all.forEach { a in
                    if var a = a.allergen {
                        a.isSelected = true
                        self.tAllergens?.append(a)
                    }
                }
            }
            if let diet = profile.dietarys {
                tDietaries = [BookingAttributesDetails]()
                diet.forEach { d in
                    if var d = d.dietary {
                        d.isSelected = true
                        self.tDietaries?.append(d)
                    }
                }
            }
            if let inter = profile.interests {
                tInterests = [BookingAttributesDetails]()
                inter.forEach { i in
                    if var i = i.interests {
                        i.isSelected = true
                        self.tInterests?.append(i)
                    }
                }
            }
        }
    }
    
    
    fileprivate func setupInterface() {
        if SocialLogger.shared.isSocialLoginEnable() {
            emailAddressTextField.isEnabled = false
            emailAddressTextField.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func selectPhotoTapped(_ sender: Any) {
        imagePicker.photoGalleryAsscessRequest()
    }
    private func registerCells() {
        interestCollectionView.register(UINib(nibName: AddProfileDetailsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: AddProfileDetailsCollectionCell.description())
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        
        allergensCollectionView.register(UINib(nibName: AddProfileDetailsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: AddProfileDetailsCollectionCell.description())
        allergensCollectionView.delegate = self
        allergensCollectionView.dataSource = self
        
        dietaryCollectionView.register(UINib(nibName: AddProfileDetailsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: AddProfileDetailsCollectionCell.description())
        dietaryCollectionView.delegate = self
        dietaryCollectionView.dataSource = self
        
        dislikeCollectionView.register(UINib(nibName: AddProfileDetailsCollectionCell.description(), bundle: nil), forCellWithReuseIdentifier: AddProfileDetailsCollectionCell.description())
        dislikeCollectionView.delegate = self
        dislikeCollectionView.dataSource = self
    }
    
    private func getBookingAttribute() {
        HomeAPIManager.GetBookingAttributes { result in
            switch result.status {
            case "Success":
                self.interests = result.interests
                self.allergens = result.allergens
                self.dietaries = result.dietaryRestrictions
                self.dislikes = result.dislikes
                self.updateUI()
            case "Fail":
                break
            default: break
            }
        }
    }
    
    fileprivate func updateUI() {
        self.mainHeight.constant = 1370
        self.allergensHeight.constant = 1
        self.dietaryHeight.constant = 1
        self.dislikeHeight.constant = 1
        self.interestHeight.constant = 1
        
        self.allergensCollectionView.reloadData()
        self.dietaryCollectionView.reloadData()
        self.dislikeCollectionView.reloadData()
        self.interestCollectionView.reloadData()
        
        let allerHeight = allergensCollectionView.collectionViewLayout.collectionViewContentSize.height
        let dietHeight = dietaryCollectionView.collectionViewLayout.collectionViewContentSize.height
        let dislikeHeight = dislikeCollectionView.collectionViewLayout.collectionViewContentSize.height
        let interestHeight = interestCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        self.allergensHeight.constant = allerHeight
        self.dietaryHeight.constant = dietHeight
        self.dislikeHeight.constant = dislikeHeight
        self.interestHeight.constant = interestHeight
        
        self.mainHeight.constant += (allerHeight + dietHeight + dislikeHeight + interestHeight)
    }
    func validateURL(url: String) -> Bool {
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: url)
        return result
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.firstnameErr.isHidden = false
            firstNameTextField.becomeFirstResponder()
            return
        }
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.lastnameErr.isHidden = false
            lastNameTextField.becomeFirstResponder()
            return
        }
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.emailErr.isHidden = false
            emailAddressTextField.becomeFirstResponder()
            return
        }
        if !emailAddressTextField.text!.isValidEmail() {
            self.emailErr.isHidden = false
            self.emailErr.text = "email address is not in correct format"
            emailAddressTextField.becomeFirstResponder()
            return
        }
        if dobTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.dobErr.isHidden = false
            dobTextField.becomeFirstResponder()
            return
        }
//        if !validateURL(url: facebookTextField.text!) {
//            return
//        }
//        if !validateURL(url: instagramTextField.text!) {
//            return
//        }
//        if !validateURL(url: twitterTextField.text!) {
//            return
//        }
//        if !validateURL(url: linkedInTextField.text!) {
//            return
//        }
        var Diet = ""
        if let diet = self.tDietaries {
            for (i, d) in diet.enumerated() {
                if i == diet.endIndex - 1 {
                    Diet += "\(d.id ?? 0)"
                } else {
                    Diet += "\(d.id ?? 0) | "
                }
            }
        }
        if Diet == "" {
            Diet = "0"
        }
        var Aller = ""
        if let tAllergens = tAllergens {
            for (i, a) in tAllergens.enumerated() {
                if i == tAllergens.endIndex - 1 {
                    Aller += "\(a.id ?? 0)"
                } else {
                    Aller += "\(a.id ?? 0) | "
                }
            }
        }
        if Aller == "" {
            Aller = "0"
        }
        var Dislike = ""
        if let tDislikes = tDislikes {
            for (i, d) in tDislikes.enumerated() {
                if i == tDislikes.endIndex - 1 {
                    Dislike += "\(d.id ?? 0)"
                } else {
                    Dislike += "\(d.id ?? 0) | "
                }
            }
        }
        if Dislike == "" {
            Dislike = "0"
        }
        var Interest = ""
        if let tInterests = tInterests {
            for (i, d) in tInterests.enumerated() {
                if i == tInterests.endIndex - 1 {
                    Interest += "\(d.id ?? 0)"
                } else {
                    Interest += "\(d.id ?? 0) | "
                }
            }
        }
        if Interest == "" {
            Interest = "0"
        }
        
        var params = [
            "first_name": firstNameTextField.text!,
            "last_name" : lastNameTextField.text!,
            "name": preferredNameTextField.text ?? "",
            "gender": gender,
            "dial_code": "+971",
            "mobile": "501234567",
            //"user_image": self.userProfile.image!,
            "date_of_birth": self.dobTextField.text ?? "",
            "interest_ids": Interest,
            "allergen_ids" : Aller,
            "dietary_ids": Diet,
            "fb_link": self.facebookTextField.text ?? "",
            "tw_link": self.twitterTextField.text ?? "",
            "in_link": self.instagramTextField.text ?? "",
            "li_link": self.linkedInTextField.text ?? "",
            "email": self.emailAddressTextField.text ?? ""
        ] as [String:Any]
        
        if SocialLogger.shared.isSocialLoginEnable() {
            params.updateValue("", forKey: "email")
        }
        let userFile:[String:[UIImage?]] = ["user_image" :[self.userProfile.image]]
        ProfileAPIManager.UpdateMyProfile(images:userFile, params: params) { model in
            switch model.status {
            case "Success":
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "UpdateMyProfile"), object: nil)
                break
            case "Fail":
                Utilities.showWarningAlert(message: model.message ?? "")
                break
            default: break
            }
        }
    }
    
    private func setupGenderButtons(tag: Int) {
        self.femaleGradient.isHidden = true
        self.maleGradient.isHidden = true
        self.discloseGradient.isHidden = true
        
        self.femaleView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
        self.maleView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
        self.discloseView.borderColor = Color.underlineColor.color().withAlphaComponent(0.5)
        
        if tag == 0 {
            gender = "Female"
            self.femaleGradient.isHidden = false
            return
        }
        if tag == 1 {
            gender = "Male"
            self.maleGradient.isHidden = false
            return
        }
        if tag == 2 {
            gender = ""
            self.discloseGradient.isHidden = false
            return
        }
    }
    @IBAction func genderBtnTapped(_ sender: UIButton) {
        setupGenderButtons(tag: sender.tag)
    }
}


extension UpdateProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            if let count = tInterests?.count {
                return count
            }
        }
        if collectionView == allergensCollectionView {
            if let count = tAllergens?.count {
                return count
            }
        }
        if collectionView == dietaryCollectionView {
            if let count = tDietaries?.count {
                return count
            }
        }
        if collectionView == dislikeCollectionView {
            if let count = tDislikes?.count {
                return count
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProfileDetailsCollectionCell.description(), for: indexPath) as! AddProfileDetailsCollectionCell
        
        if collectionView == interestCollectionView {
            if let data = self.tInterests?[indexPath.row] {
                if data.isSelected {
                    cell.xMarkBtn.tag = indexPath.row
                    cell.xMarkBtn.addTarget(self, action: #selector(removeEntry(sender:)), for: .touchUpInside)
                    cell.xMarkBtn.accessibilityLabel = "interests"
                    cell.titleLbl.text = data.title
                }
            }
            return cell
        }
        if collectionView == allergensCollectionView {
            if let data = self.tAllergens?[indexPath.row] {
                if data.isSelected {
                    cell.xMarkBtn.tag = indexPath.row
                    cell.xMarkBtn.addTarget(self, action: #selector(removeEntry(sender:)), for: .touchUpInside)
                    cell.xMarkBtn.accessibilityLabel = "allergens"
                    cell.titleLbl.text = data.title
                }
            }
            return cell
        }
        if collectionView == dietaryCollectionView {
            if let data = self.tDietaries?[indexPath.row] {
                if data.isSelected {
                    cell.xMarkBtn.tag = indexPath.row
                    cell.xMarkBtn.addTarget(self, action: #selector(removeEntry(sender:)), for: .touchUpInside)
                    cell.xMarkBtn.accessibilityLabel = "dietary"
                    cell.titleLbl.text = data.title
                }
            }
            return cell
        }
        if collectionView == dislikeCollectionView {
            if let data = self.tDislikes?[indexPath.row] {
                if data.isSelected {
                    cell.xMarkBtn.tag = indexPath.row
                    cell.xMarkBtn.addTarget(self, action: #selector(removeEntry(sender:)), for: .touchUpInside)
                    cell.xMarkBtn.accessibilityLabel = "dislike"
                    cell.titleLbl.text = data.title
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    @objc private func removeEntry(sender:UIButton) {
        if sender.accessibilityLabel == "dietary" {
            self.tDietaries!.remove(at: sender.tag)
            self.dietaryCollectionView.reloadData()
            return
        }
        if sender.accessibilityLabel == "allergens" {
            self.tAllergens!.remove(at: sender.tag)
            self.allergensCollectionView.reloadData()
            return
        }
        if sender.accessibilityLabel == "dislike" {
            self.tDislikes!.remove(at: sender.tag)
            self.dislikeCollectionView.reloadData()
            return
        }
        if sender.accessibilityLabel == "interests" {
            self.tInterests!.remove(at: sender.tag)
            self.interestCollectionView.reloadData()
            return
        }
        updateUI()
    }
}

extension UpdateProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        if collectionView == interestCollectionView {
            label.text = self.tInterests![indexPath.item].title ?? ""
        }
        if collectionView == allergensCollectionView {
            label.text = self.tAllergens![indexPath.item].title ?? ""
        }
        if collectionView == dietaryCollectionView {
            label.text = self.tDietaries![indexPath.item].title ?? ""
        }
        if collectionView == dislikeCollectionView {
            label.text = self.tDislikes![indexPath.item].title ?? ""
        }
        
        label.sizeToFit()
        return CGSize(width: label.frame.width + 30, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTextField {
            let maxDate = Date()
            let minDate = Date().dateByAddingYears(-150)
            RPicker.selectDate(title: "Select Date of Birth", minDate: minDate, maxDate: maxDate) { [weak self] (selectedDate) in
                // TODO: Your implementation for date
                self?.dobTextField.text = selectedDate.dateString("yyyy-MM-dd")
                
            }
            return false
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddProfileDetailPopupViewController") as! AddProfileDetailPopupViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.updateProfileDelegate = self
        if textField == interestTextField {
            controller.interest = self.interests
            self.present(controller, animated: true, completion: nil)
            return false
        }
        if textField == allergensTextField {
            controller.allergens = self.allergens
            self.present(controller, animated: true, completion: nil)
            return false
        }
        if textField == dietaryTextField {
            controller.dietaries = self.dietaries
            self.present(controller, animated: true, completion: nil)
            return false
        }
        if textField == dislikeTextField {
            if let count = self.dislikes?.count {
                controller.dislikes = self.dislikes
                self.present(controller, animated: true, completion: nil)
            } else {
                Utilities.showWarningAlert(message: "No detail found for dislikes")
            }
            return false
        }
        return true
    }
}

extension UpdateProfileViewController: UpdateProfileDelegate {
    func updateAllergens(allergens: BookingAttributesDetails) {
        var i = allergens
        i.isSelected = true
        if self.tAllergens == nil {
            self.tAllergens = [i]
        } else {
            self.tAllergens?.append(i)
        }
        allergensCollectionView.reloadData()
        updateUI()
    }
    
    func updateDietaries(dietaries: BookingAttributesDetails) {
        var i = dietaries
        i.isSelected = true
        if self.tDietaries == nil {
            self.tDietaries = [i]
        } else {
            self.tDietaries?.append(i)
        }
        dietaryCollectionView.reloadData()
        updateUI()
    }
    
    func updateDislikes(dislikes: BookingAttributesDetails) {
        var i = dislikes
        i.isSelected = true
        if self.tDislikes == nil {
            self.tDislikes = [i]
        } else {
            self.tDislikes?.append(i)
        }
        dislikeCollectionView.reloadData()
        updateUI()
    }
    
    func updateInterest(interest: BookingAttributesDetails) {
        var i = interest
        i.isSelected = true
        if self.tInterests == nil {
            self.tInterests = [i]
        } else {
            self.tInterests?.append(i)
        }
        interestCollectionView.reloadData()
        updateUI()
    }
}


extension UpdateProfileViewController: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
            userProfile.image = image
        userProfile.contentMode = .scaleToFill
            imagePicker.dismiss()
        }

        func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
        func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                         to sourceType: UIImagePickerController.SourceType) {
            guard grantedAccess else { return }
            imagePicker.present(parent: self, sourceType: sourceType)
        }
}
