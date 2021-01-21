//
//  LogInViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit


class LogInViewController: UIViewController {
    private enum Constants {
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
    
    private func autoComplete() {
        emailTextField.text = "junior-ios-developer@mailinator.com"
        passwordTextField.text = "s4m8AJDbVvX4H8aF"
    }
        
    @IBAction func signInTapped(_ sender: Any) {
        autoComplete() // for comfort and not entering it manually
        //validate all the fields
        let isValidAllFields = validateFields()
        if !isValidAllFields {
            errorMessage.isHidden = false
            errorMessage.alpha = 1
        }
        else {
            let email = emailTextField.text!
            let password = passwordTextField.text!
       
            // login session
            NetworkManager().login(email: email, password: password, completion: { result, error in
                if (result != nil) {
                    // if the key is saved -> navigating to TabBar
                    if KeychainManager().saveAccessToken(result?.object(forKey: "access_token") as! String){
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
