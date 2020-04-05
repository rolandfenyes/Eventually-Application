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
    
    @IBOutlet weak var headTitle: UILabel!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var numOfPeople: UITextField!
    @IBOutlet weak var shortDesc: UITextField!
    
    //variables for the location
    @IBOutlet weak var location: UIButton!
    private var map: MapLoader!
    //private var locationCoordinates: CLLocationCoordinate2D?
    @IBOutlet weak var showLocationOnMap: MKMapView!
    
    //variables for the date
    @IBOutlet weak var startDate: UITextField!
    private var startDatePicker: UIDatePicker?
    private var startDateDate: Date?
    @IBOutlet weak var endDate: UITextField!
    private var endDatePicker: UIDatePicker?
    
    //variables for the publicity
    @IBOutlet weak var publicityInput: UITextField!
    private var pubPicker: UIPickerView?
    
    //variables for the event image
    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage?
    
    //variables for error message and create event button
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var eventCreateButton: UIButton!
    
    //MARK: - Variables for editing
    private var editedEvent: Event?
    private var isEditModeOn: Bool! = false
    
    func setEventToEdit(event: Event) {
        self.editedEvent = event
        isEditModeOn = true
    }
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        
        publicityInput.text = dataSourceOfPubPicker[0]

        startDatePicking()
        endDatePicker?.isEnabled = false
        //endDatePicking()
        PublicityPicking()
        LocationSingleton.shared().attach(observer: self)
        map = MapLoader(map: showLocationOnMap)
        
        if (isEditModeOn) {
            setUpEditing()
        }
    }
    
    //MARK: - Set up editing
    
    func setUpEditing() {
        headTitle.text = "Szerkesztés"
        eventName.text = self.editedEvent?.getName()
        numOfPeople.text = self.editedEvent?.getGuests()
        shortDesc.text = self.editedEvent?.getDescription()
        location.setTitle(self.editedEvent?.getAddress(), for: .normal)
        startDate.text = self.editedEvent?.getStartDate()
        endDate.text = self.editedEvent?.getEndDate()
        publicityInput.text = self.editedEvent?.getPub()
        imageView.image = self.editedEvent?.getImage()
        eventCreateButton.setTitle("Befejezés", for: .normal)
        setUpMiniMap()
    }
    
    func setUpMiniMap() {
        let title = self.editedEvent!.getAddress()
        let coordinates = self.editedEvent!.getEventLocation()
        LocationSingleton.shared().setLocation(coordinates: coordinates, text: title)
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        self.showLocationOnMap?.addAnnotation(annotation)
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self .showLocationOnMap?.setRegion(region, animated: false)
        
    }
    
    //MARK: - Observer
    
    func update() {
        let title = LocationSingleton.shared().getText()
        location.setTitle(title, for: .normal)
        map.showMap(coordinates: LocationSingleton.shared().getCoordinates()!, animation: false, title: title, mapRange: 0.01)
        
    }
    
    //MARK: - Check inputs
    
    func checkInputsValidaton() -> Bool {
        if (eventName.text!.count > 3 &&
            LocationSingleton.shared().getCoordinates() != nil &&
            Int(numOfPeople.text!) ?? -1 > 0 &&
            shortDesc.text!.count > 10) {
            return true
        }else {
            setErrorMessageDependingOnError()
            return false
        }
    }
    
    func setErrorMessageDependingOnError() {
        errorMessage.isHidden = false
        if eventName.text!.count <= 2 {
            errorMessage.text = "Adj címet az eseménynek!"
        }
        else if eventName.text!.count > 15 {
            errorMessage.text = "Túl hosszú cím!"
        }
        else if Int(numOfPeople.text!) ?? -1 < 0 {
            errorMessage.text = "Valós számot adj meg!"
        }
        else if shortDesc.text!.count < 10 {
            errorMessage.text = "A leírás legalább 10 karakter!"
        }
        else {
            errorMessage.text = "Minden kötelező* mezőt tölts ki!"
        }
    }
    
    func setErrorMessageHidden() {
        errorMessage.isHidden = true
    }
    
    //MARK: - Event Created Button Pressed
    
    @IBAction func eventCreatedButtonPressed(_ sender: Any) {
        if checkInputsValidaton(){
            setErrorMessageHidden()
            var buttonMessage: String?
            
            if (isEditModeOn) {
                let modifiedEvent = createEvent()
                editEvent(modifiedEvent: modifiedEvent)
                dismiss(animated: true, completion: nil)
            }
            else {
                let newEvent = createEvent()
                EventHandler.shared().addEvent(event: newEvent)
                buttonMessage = "Létrehozva"
            }
            
            
            eventCreateButton.setTitle(buttonMessage, for: .normal)
            eventCreateButton.isEnabled = false
        }
     }
    
    func createEvent() -> Event {
        let event = Event(eventName: eventName.text!, eventLocation: LocationSingleton.shared().getCoordinates()!, numberOfPeople: numOfPeople.text!, shortDescription: shortDesc.text!, startDate: startDate.text!, endDate: endDate.text!, publicity: publicityInput.text!, image: imageView.image, address: LocationSingleton.shared().getText())
        return event
    }
    
    func editEvent(modifiedEvent: Event) {
        EventHandler.shared().editEvent(oldEvent: self.editedEvent!, modifiedEvent: modifiedEvent)
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
    
    func startDatePicking() {
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .dateAndTime
        startDatePicker?.minimumDate = startDatePicker?.date
        startDatePicker?.addTarget(self, action: #selector(startDateChanged(datePicker:)), for: .valueChanged)
        startDate.inputView = startDatePicker
        SetUpDoneButton(pickerType: "DatePicker")
    }
    
    func endDatePicking() {
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .dateAndTime
        endDatePicker?.minimumDate = startDateDate
        endDatePicker?.addTarget(self, action: #selector(endDateChanged(datePicker:)), for: .valueChanged)
        endDate.inputView = endDatePicker
        SetUpDoneButton(pickerType: "DatePicker")
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd '-' hh:mm a"  //"hh:mm a 'on' dd"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        startDate.text = dateFormatter.string(from: datePicker.date)
        startDateDate = datePicker.date
        endDatePicker?.isEnabled = true
        endDatePicking()
    }
    
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd '-' hh:mm a"  //"hh:mm a 'on' dd"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        endDate.text = dateFormatter.string(from: datePicker.date)
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
        case "DatePicker":  startDate.inputAccessoryView = doneButton
                            endDate.inputAccessoryView = doneButton
                            break
        case "PubPicker":   publicityInput.inputAccessoryView = doneButton
                            break
        default: break
        }
        
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}

