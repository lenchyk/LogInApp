//
//  LogOutViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit
import SwiftKeychainWrapper

class LogOutViewController: UIViewController {

    @IBOutlet var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func goBack() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func logOutTapped(_ sender: Any) {
        // deleting the key - access_token
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: "access_token")
        print("removed successfully - \(removeSuccessful)")
        
        // going back to login screen
        goBack()
    }
}
