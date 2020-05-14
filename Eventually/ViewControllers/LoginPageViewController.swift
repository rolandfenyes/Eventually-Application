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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    private var imageList: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createImageList()
        loginButton.layer.cornerRadius = 10

        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.image.image = self.imageList.randomElement()
        }
        timer.fire()
    }
    
    func createImageList() {
        imageList.append(UIImage(named: "burger")!)
        imageList.append(UIImage(named: "campfire")!)
        imageList.append(UIImage(named: "Ice-cream")!)
        imageList.append(UIImage(named: "biking")!)
        imageList.append(UIImage(named: "beer")!)
        imageList.append(UIImage(named: "3D-Glasses-icon")!)
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
