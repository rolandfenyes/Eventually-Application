//
//  ProfileEditingViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 15..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class ProfileEditingViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    //MARK: - Variables
    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileDescription: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    private var datePicker: DatePicker?
    private let profile = Profile.shared()
    private let formatter: DateFormatter = DateFormatter()
    private var imagePicker: ImagePicker?
    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFormatter()
        loadProfile()
        
        self.datePicker = DatePicker(viewController: self)
        self.imagePicker = ImagePicker(viewController: self)

        birthDateChanged()
    }
    
    //MARK: - Load Profile
    
    func loadProfile() {
        self.profileName.text = profile.getNickname()
        self.birthDate.text = dateFormatter(date: profile.getBirthDate())
        self.emailAddress.text = profile.getEmailAddress()
        self.password.text = profile.getPassword()
        self.profilePicture.image = profile.getProfilePicture()
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
        self.datePicker!.setDatePicker(mode: .date, textField: self.birthDate, minimumDate: nil).addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker!.setDate(date: self.profile.getBirthDate(), animated: true)
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
    
    //MARK: - Buttons
    
    @IBAction func changeProfilePicture(_ sender: UIButton) {
        imagePicker?.importImage(allowsEditing: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        disappearScreen()
    }
    
    @IBAction func save(_ sender: UIButton) {
        saveProfileDetails()
        disappearScreen()
    }
    
    //MARK: - Service functions
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setChosenImage(image: image)
       }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setChosenImage(image: UIImage) {
        self.profilePicture.image = image
    }
    
    func saveProfileDetails() {
        self.profile.changeProfile(nickname: self.profileName.text!, birthDate: dateFormatter(date: self.birthDate.text!)!, email: self.emailAddress.text!, password: self.password.text!, profilePicture: self.profilePicture.image!)
    }
    
    func disappearScreen() {
        dismiss(animated: true, completion: nil)
    }
    
} //end of the class
