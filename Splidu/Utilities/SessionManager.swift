//
//  SessionManager.swift
//  Splidu
//
//  Created by NaheedPK on 15/09/2022.
//

import Foundation
class SessionManager {
    class func isLoggedIn() -> Bool {
        guard let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool else { return false }
        return isLoggedIn
    }
    
    class func isLocationSet() -> Bool {
        guard let isLocationSet = UserDefaults.standard.value(forKey: "isLocationSet") as? Bool else { return false }
        return isLocationSet
    }
    
    class func getUserData() -> UserLogin? {
        guard let data = UserDefaults.standard.object(forKey: "UserDetails") as? Data else { return nil }
        guard let userDict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] else { return nil }
        do {
            let json = try JSONSerialization.data(withJSONObject: userDict)
            let object = try JSONDecoder().decode(UserLogin.self, from: json)
            return object
        } catch let err {
            print(err)
            return nil
        }
    }
    
    class func setLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    class func setLocation() {
        UserDefaults.standard.set(true, forKey: "isLocationSet")
        UserDefaults.standard.synchronize()
    }
    
    class func setUserData(dictionary: NSDictionary?) {
        UserDefaults.standard.set( try? NSKeyedArchiver.archivedData(withRootObject: dictionary as Any, requiringSecureCoding: false), forKey: "UserDetails")
        UserDefaults.standard.synchronize()
    }
    
    class func setCurrentLocation(_ latitude: String,_ longitude: String?) {
        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.synchronize()
    }
    
    class func getCurrentLocation() -> (String, String)? {
        let dubaiCoordiantes = ("25.2048", "55.2708")
        guard let latitude = UserDefaults.standard.value(forKey: "latitude") as? String else { return dubaiCoordiantes }
        guard let longitude = UserDefaults.standard.value(forKey: "longitude") as? String else { return dubaiCoordiantes }
        return (String(latitude.prefix(7)), String(longitude.prefix(7)))
    }
    
    class func clearLoginSession() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "UserDetails")
        UserDefaults.standard.removeObject(forKey: "AllSavedContacts")
        UserDefaults.standard.removeObject(forKey: "contacts")
        UserDefaults.standard.removeObject(forKey: UserDefaults.AppUserDefault.isRemeberLoginUser)
        SocialLogger.shared.disableSocialLogin()
        UserDefaults.standard.synchronize()
    }
    
    class func getAccessToken() -> String? {
        let userData = getUserData()
        return userData?.token
    }
    
    open class func setFCMToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "FCM_Token")
        UserDefaults.standard.synchronize()
    }
    
    open class func getFCMToken() -> String? {
        guard let fcmToken = UserDefaults.standard.value(forKey: "FCM_Token") as? String else {
            return "abdhjef ekef kjwf wedfw"
        }
        return fcmToken
    }
}
