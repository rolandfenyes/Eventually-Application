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
    
    private var correctDate: Date?
    private var datePicker: DatePicker?
    private let profile = Profile.shared()
    private let formatter: DateFormatter = DateFormatter()
    private var imagePicker: ImagePicker?
    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFormatter()
        loadProfile()
        setProfilePictureRoundly()
        
        self.datePicker = DatePicker(viewController: self)
        self.imagePicker = ImagePicker(viewController: self)

        birthDateChanged()
        setDoneButtonToKeyboards()
    }
    
    func setDoneButtonToKeyboards() {
        profileName.addDoneButtonToKeyboard()
        emailAddress.addDoneButtonToKeyboard()
        password.addDoneButtonToKeyboard()
        profileDescription.addDoneButtonToKeyboard()
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
        formatter.dateFormat = "yyyy-MM-dd"
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
        self.datePicker!.setDatePicker(mode: .date, textField: self.birthDate, minimumDate: nil).addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        self.datePicker!.setDate(date: self.profile.getBirthDate(), animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        self.datePicker!.setSelectedDate(date: datePicker.date)
        
        let dateFormatter = correctDateFormatter()
        
        self.correctDate = dateFormatter.date(from: dateFormatter.string(from: datePicker.date))
        self.datePicker!.getTextField().text! = self.dateFormatter(date: correctDate!)!
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
        let userManager = UserManager()
        let userStructure = UserStructure(id: profile.getID(), email: profile.getEmailAddress(), username: profile.getNickname(), birthdate: dateToString(), pw: profile.getPassword())
        userManager.register(userStructure, httpMethod: "PUT", addToURL: "/\(Int(userStructure.id!))", completion:  { result in
                   switch result {
                   case .success(let message):
                       print(message)
                   case .failure(let error):
                       print(error)
                   }
               })
        disappearScreen()
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: correctDate!)
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
        self.profile.changeProfile(id: self.profile.getID(), nickname: self.profileName.text!, birthDate: dateFormatter(date: self.birthDate.text!)!, email: self.emailAddress.text!, password: self.password.text!, profilePicture: self.profilePicture.image!)
    }
    
    func disappearScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    func setProfilePictureRoundly() {
        profilePicture.layer.borderWidth = 0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
    }
    
} //end of the class
