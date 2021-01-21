//
//  LogInViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

//correct user information for comfort
struct userConstants {
    let email = "junior-ios-developer@mailinator.com"
    let password = "s4m8AJDbVvX4H8aF"
    let projectId = "58b3193b-9f15-4715-a1e3-2e88e375f62b"
}

class LogInViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // the main function for checking the correct email and password
    private func validateFields() -> Bool {
        // Check that all fields are not empty
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorMessage.text = "Please, fill all the fields."
            return false
        }
        
        // check whether password is secure (at least 8 chars, 1 upper and lower case and 1 digit)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword) {
            errorMessage.text = "Please, create a good password"
            return false
        }
        return true
    }
    
    // function for checking the good secure password
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    private func transitionToSettings() {
        let settingsViewController = storyboard?.instantiateViewController(identifier: "LogOutViewController") as? LogOutViewController
        view.window?.rootViewController = settingsViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        let user = userConstants()
        emailTextField.text = user.email
        passwordTextField.text = user.password
        let projectId = user.projectId
        
        //validate all the fields
        let isValidAllFields = validateFields()
        if !isValidAllFields {
            errorMessage.isHidden = false
            errorMessage.alpha = 1
        }
        else {
            let user = emailTextField.text!
            let password = passwordTextField.text!
       
            let parameters: Parameters = ["email": user, "password": password, "project_id": projectId]
            // login session
            AF.request("https://api-qa.mvpnow.io/v1/sessions", method: .post, parameters: parameters).response {
                response in
                switch response.result {
                case .success(let data):
                    self.transitionToSettings()
                    let json = try! JSONSerialization.jsonObject(with: data!,
                                                                 options: []) as? NSDictionary
                    // saving the token to keychain
                    let saveSuccessful: Bool = KeychainWrapper.standard.set((json?.object(forKey: "access_token")
                                                                                as? String)!, forKey: "access_token")
                    print("saved successfully - \(saveSuccessful)")
                case .failure(let error):
                    print(error)
                    self.errorMessage.text = "Something went wrong"
                    self.errorMessage.isHidden = false
                }
            }
        }
    }
}
