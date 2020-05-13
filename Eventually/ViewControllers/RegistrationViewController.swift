//
//  RegistrationViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private var datePicker: DatePicker?
    private let formatter: DateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFormatter()
        self.datePicker = DatePicker(viewController: self)
        
        birthDateChanged()
    }
    
    func setUpFormatter() {
        formatter.dateFormat = "yyyy/MM/dd"
    }
    
    func dateFormatter(date: Date) -> String? {
        return formatter.string(from: date)
    }
    
    func dateFormatter(date: String) -> Date? {
        return formatter.date(from: date)
    }
    
    //MARK: - BirthDate Changed
    
    func birthDateChanged() {
        self.datePicker!.setDatePicker(mode: .date, textField: self.birthday, minimumDate: nil).addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker!.setDate(date: Date(), animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        self.datePicker!.setSelectedDate(date: datePicker.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        
        self.datePicker!.getTextField().text! = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let postRequest = UserManager()
        let user = UserStructure(id: 0, email: emailAddress.text, username: nickname.text, birthdate: birthday.text, pw: password.text)
        postRequest.register(user, completion: { result in
            switch result {
            case .success(let message):
                let homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "startPage") as! UITabBarController
                self.navigationController?.pushViewController(homeScreen, animated: true)
            case .failure(let error):
                print(error)
            }
        })
        
        
    }

}
