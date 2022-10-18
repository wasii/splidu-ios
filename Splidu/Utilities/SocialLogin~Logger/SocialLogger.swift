//
//  SocialLogger.swift
//
//  Created by Muneeb on 25/05/2022.
//

import Foundation
class SocialLogger {
    static let shared = SocialLogger()
    private init() {}
    
    func enableSocialLogin() {
        UserDefaults.standard.setValue(true, forKey: UserDefaults.AppUserDefault.socialLogin)
    }
    
    func disableSocialLogin() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.AppUserDefault.socialLogin)
    }
    
    func isSocialLoginEnable() -> Bool {
        guard let isSocialLogin = UserDefaults.standard.object(forKey: UserDefaults.AppUserDefault.socialLogin) as? Bool else { return false }
        return isSocialLogin
    }
}
