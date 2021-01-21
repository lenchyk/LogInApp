//
//  KeychainManager.swift
//  LoginApp
//
//  Created by Lena Soroka on 21.01.2021.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager {
    private enum KeyChainConstants {
        static let keyForToken = "access_token"
    }
    
    func saveAccessToken(_ accessToken: String) -> Bool {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(accessToken, forKey: KeyChainConstants.keyForToken)
        return saveSuccessful
    }
    
    func removeAccessToken() -> Bool {
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KeyChainConstants.keyForToken)
        return removeSuccessful
    }
}
