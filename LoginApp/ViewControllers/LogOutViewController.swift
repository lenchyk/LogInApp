//
//  LogOutViewController.swift
//  LoginApp
//
//  Created by Lena Soroka on 20.01.2021.
//

import UIKit

class LogOutViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func logOutTapped(_ sender: Any) {
        // To-Do transition
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController
        self.present(loginViewController!, animated: true, completion: nil)
    }
}
