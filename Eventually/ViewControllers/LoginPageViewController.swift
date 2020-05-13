//
//  LoginPageViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func login(_ sender: UIButton) {
        let userManager = UserManager()
        userManager.downloadUsers()
        if userManager.auth(email: emailAddress.text!, password: password.text!) {
            let homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "startPage") as! UITabBarController
            self.navigationController?.pushViewController(homeScreen, animated: true)
        }
    }
    

}
