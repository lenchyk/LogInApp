//
//  LogInViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper


class LogInViewController: UIViewController {
    private enum Constants {
        enum MockCredentials {
            static let email = "junior-ios-developer@mailinator.com"
            static let password = "s4m8AJDbVvX4H8aF"
            static let projectId = "58b3193b-9f15-4715-a1e3-2e88e375f62b"
        }
        enum RequestParameters {
            static let email = "email"
            static let password = "password"
            static let projectId = "project_id"
            static let url = "https://api-qa.mvpnow.io/v1/sessions"
        }
        enum Errors {
            static let emptyTextField = "Please, fill all the fields."
            static let unsecurePassword = "Please, create a good password"
            static let networkRequestFailed = "Something went wrong"
        }
    }
    
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
            errorMessage.text = Constants.Errors.emptyTextField
            return false
        }
        
        // check whether password is secure (at least 8 chars, 1 upper and lower case and 1 digit)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword) {
            errorMessage.text = Constants.Errors.unsecurePassword
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
    
    private func navigate() {
        let menuViewController = storyboard?.instantiateViewController(identifier: "TabBarController")
        view.window?.rootViewController = menuViewController
        view.window?.makeKeyAndVisible()
    }
        
    @IBAction func signInTapped(_ sender: Any) {
        emailTextField.text = Constants.MockCredentials.email
        passwordTextField.text = Constants.MockCredentials.password
        
        //validate all the fields
        let isValidAllFields = validateFields()
        if !isValidAllFields {
            errorMessage.isHidden = false
            errorMessage.alpha = 1
        }
        else {
            let user = emailTextField.text!
            let password = passwordTextField.text!
            let projectId = Constants.MockCredentials.projectId // where should I get this ID?
       
            let parameters: Parameters = [Constants.RequestParameters.email: user, Constants.RequestParameters.password: password, Constants.RequestParameters.projectId: projectId]
            
            
            // login session
            NetworkManager().login(url: Constants.RequestParameters.url, credentials: parameters, completion: { result, error in
                if (result != nil) {
                    // if the key is saved -> navigating to TabBar
                    if KeychainManager().saveKey(json: result) {
                        self.navigate()
                    }
                }
                else {
                    self.errorMessage.text = Constants.Errors.networkRequestFailed
                    self.errorMessage.isHidden = false
                }
            })
        }
    }
}
