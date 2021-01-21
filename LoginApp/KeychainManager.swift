//
//  KeychainManager.swift
//  LoginApp
//
//  Created by Lena Soroka on 21.01.2021.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager {
    func saveKey(json: NSDictionary?) -> Bool {
        let saveSuccessful: Bool = KeychainWrapper.standard.set((json?.object(forKey: "access_token") as? String)!,
                                                                forKey: "access_token")
        return saveSuccessful
    }
    
    func removeKey(keyNameSaved: String) -> Bool {
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: keyNameSaved)
        return removeSuccessful
    }
}
