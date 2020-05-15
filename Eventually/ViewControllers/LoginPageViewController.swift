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
        emailAddress.addDoneButtonToKeyboard()
        password.addDoneButtonToKeyboard()
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

//MARK: - keyboard done button

extension UITextField {
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        } set (hasDone) {
            addDoneButtonToKeyboard()
        }
    }
    
    func addDoneButtonToKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
