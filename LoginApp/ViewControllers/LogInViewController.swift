//
//  LogInViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // the main function for checking the correct email and password
    func validateFields() -> String? {
        // Check that all fields are not empty
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorMessage.isHidden = false
            return "Please, fill all the fields."
        }
        
        // check whether password is secure (at least 8 chars, 1 upper and lower case and 1 digit)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword) {
            errorMessage.isHidden = false
            return "Please, create a good password"
        }
        return nil
    }
    
    // function for checking the good password
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func transitionToSettings() {
        let settingsViewController = storyboard?.instantiateViewController(identifier: "LogOutViewController") as? LogOutViewController
        view.window?.rootViewController = settingsViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        emailTextField.text = "junior-ios-developer@mailinator.com"
        passwordTextField.text = "s4m8AJDbVvX4H8aF"
        
        //validate all the fields
        let error = validateFields()
        if error != nil {
            errorMessage.text = error!
            errorMessage.alpha = 1
        }
        else {
            
            // login session
            let user = emailTextField.text!
            let password = passwordTextField.text!
            //???
            let credential = URLCredential(user: user, password: password, persistence: .forSession)
            
            let parameters: Parameters = ["email": user, "password": password, "project_id": "58b3193b-9f15-4715-a1e3-2e88e375f62b"]
            
            AF.request("https://api-qa.mvpnow.io/v1/sessions", method: .get, parameters: parameters)
                        .authenticate(with: credential)
                        .validate()
                        .responseString { result in
                      if let error = result.error {
                        print(error)
                      }
                      if let receivedString = result.value {
                        print(receivedString)
                      }
                
                        }
            
        }
    }
}
