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
    
    private var correctDate: Date?
    private var datePicker: DatePicker?
    private let formatter: DateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFormatter()
        self.datePicker = DatePicker(viewController: self)
        
        birthDateChanged()
        setDoneButtonToKeyboards()
    }
    
    func setDoneButtonToKeyboards() {
        nickname.addDoneButtonToKeyboard()
        birthday.addDoneButtonToKeyboard()
        emailAddress.addDoneButtonToKeyboard()
        password.addDoneButtonToKeyboard()
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
    
    func correctDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    func correctDateToString() -> String {
        let formatter = correctDateFormatter()
        return formatter.string(from: correctDate!)
    }
    
    //MARK: - BirthDate Changed
    
    func birthDateChanged() {
        self.datePicker!.setDatePicker(mode: .date, textField: self.birthday, minimumDate: nil).addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker!.setDate(date: Date(), animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        self.datePicker!.setSelectedDate(date: datePicker.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        self.correctDate = dateFormatter.date(from: dateFormatter.string(from: datePicker.date))
        self.datePicker!.getTextField().text! = self.dateFormatter(date: correctDate!)!
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let postRequest = UserManager()
        let user = UserStructure(id: 0, email: emailAddress.text, username: nickname.text, birthdate: self.correctDateToString(), pw: password.text)
        postRequest.register(user, httpMethod: "POST", addToURL: "", completion: { result in
            switch result {
            case .success(let message):
                self.openLogin()
            case .failure(let error):
                if error == .decodingProblem {
                    self.openLogin()
                }
            }
        })
    }
    
    func openLogin() {
        DispatchQueue.main.async {
            let loginScreen = self.storyboard?.instantiateViewController(identifier: "login") as! LoginPageViewController
            self.navigationController?.pushViewController(loginScreen, animated: true)
        }
        
    }

}

