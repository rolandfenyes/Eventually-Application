//
//  LoginPageViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "startPage") as! UITabBarController
        self.navigationController?.pushViewController(homeScreen, animated: true)
        //self.present(homeScreen, animated: true, completion: nil)
    }
    

}
