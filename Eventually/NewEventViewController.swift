//
//  NewEventViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 02..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit
import MapKit

class NewEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PObserver {

    //MARK: - Variables
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var numOfPeople: UITextField!
    @IBOutlet weak var shortDesc: UITextField!
    
    //variables for the location
    @IBOutlet weak var location: UIButton!
    private var map: MapLoader!
    //private var locationCoordinates: CLLocationCoordinate2D?
    @IBOutlet weak var showLocationOnMap: MKMapView!
    
    //variables for the date
    @IBOutlet weak var dateInput: UITextField!
    private var datePicker: UIDatePicker?
    
    //variables for the publicity
    @IBOutlet weak var publicityInput: UITextField!
    private var pubPicker: UIPickerView?
    
    //variables for the event image
    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage?
    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publicityInput.text = dataSourceOfPubPicker[0]

        DatePicking()
        PublicityPicking()
        LocationSingleton.shared().attach(observer: self)
        map = MapLoader(map: showLocationOnMap)
    }
    
    func update() {
        
        let title = LocationSingleton.shared().getText()
        location.setTitle(title, for: .normal)
        map.showMap(coordinates: LocationSingleton.shared().getCoordinates(), animation: false, title: title, mapRange: 0.01)
        
    }
    
    //MARK: - Event Created Button Pressed
    
    @IBAction func eventCreatedButtonPressed(_ sender: Any) {
        print("gomb lenyomva")
        print(eventName.text!)
        print(LocationSingleton.shared().getCoordinates())
        print(numOfPeople.text!)
        print(shortDesc.text!)
        print(dateInput.text!)
        print(publicityInput.text!)
        print(LocationSingleton.shared().getText())
        let event = Event(eventName: eventName.text!, eventLocation: LocationSingleton.shared().getCoordinates(), numberOfPeople: numOfPeople.text!, shortDescription: shortDesc.text!, dateOfEvent: dateInput.text!, publicity: publicityInput.text!, image: imageView.image, address: LocationSingleton.shared().getText())
        EventHandler.shared().addEvent(event: event)
     }
    
    
    //MARK: - Image Picker
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            self.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Publicity Picker
    
    private let dataSourceOfPubPicker = ["Publikus", "Privát"]
    
    func PublicityPicking() {
        pubPicker = UIPickerView()
        pubPicker?.delegate = self
        pubPicker?.dataSource = self
        publicityInput.inputView = pubPicker
        SetUpDoneButton(pickerType: "PubPicker")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceOfPubPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceOfPubPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        publicityInput.text = dataSourceOfPubPicker[row]
    }
    
    //MARK: - Date Picker
    
    func DatePicking(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewEventViewController.DateChanged(datePicker:)), for: .valueChanged)
        dateInput.inputView = datePicker
        SetUpDoneButton(pickerType: "DatePicker")
    }
    
    @objc func DateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd '-' hh:mm a"  //"hh:mm a 'on' dd"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateInput.text = dateFormatter.string(from: datePicker.date)
    }
    
    // MARK: - Done Button
    
    func SetUpDoneButton(pickerType: String) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DoneButtonPressed(sender: )))
        doneButton.tintColor = UIColor.black
        toolBar.setItems([space, doneButton], animated: true)
        toolBar.sizeToFit()
        AddDoneButton(doneButton: toolBar, pickerType: pickerType)
    }
    
    func AddDoneButton(doneButton : UIToolbar, pickerType: String) {
        switch (pickerType) {
        case "DatePicker": dateInput.inputAccessoryView = doneButton
        case "PubPicker": publicityInput.inputAccessoryView = doneButton
        default: break
        }
        
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}

