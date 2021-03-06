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
    
    var datePicker: DatePicker!
    var datePicker2: DatePicker!
    private var isEndDateEnabled: Bool!
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    //variables for the publicity
    @IBOutlet weak var publicityInput: UITextField!
    private var pubPicker: UIPickerView?
    
    //variables for the event image
    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage?
    var imagePicker: ImagePicker!

    
    //variables for error message and create event button
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var eventCreateButton: UIButton!
    
    @IBOutlet weak var isOnlineSwitch: UISwitch!
    
    //MARK: - Variables for editing
    private var editedEvent: Event?
    private var isEditModeOn: Bool! = false
    @IBOutlet weak var cancelButton: UIButton!
    
    func setEventToEdit(event: Event) {
        self.editedEvent = event
        isEditModeOn = true
    }
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.isHidden = true
        
        self.imagePicker = ImagePicker(viewController: self)

        modifyCancelButtonDependingOnEditMode()
        
        publicityInput.text = dataSourceOfPubPicker[0]

        self.datePicker = DatePicker(viewController: self)
        self.datePicker2 = DatePicker(viewController: self)
        
        startDatePicking()
        isEndDateEnabled = false

        PublicityPicking()
        LocationSingleton.shared().attach(observer: self)
        map = MapLoader(map: showLocationOnMap)
        
        isOnlineSwitch.setOn(false, animated: false)
        
        if (isEditModeOn) {
            setUpEditing()
        }
        setDoneButtonToKeyboards()
    }
    
    func setDoneButtonToKeyboards() {
        eventName.addDoneButtonToKeyboard()
        numOfPeople.addDoneButtonToKeyboard()
        shortDesc.addDoneButtonToKeyboard()
    }
    
    func modifyCancelButtonDependingOnEditMode() {
        if (!self.isEditModeOn) {
            cancelButton.isHidden = true
            cancelButton.isEnabled = false
        }
        else {
            cancelButton.isHidden = false
            cancelButton.isEnabled = true
        }
    }
    
    
    @IBAction func isOnlineSwitchValueChanged(_ sender: Any) {
        if isOnlineSwitch.isOn {
            location.isEnabled = false
        } else {
            location.isEnabled = true
        }
    }
    
    //MARK: - Set up editing
    
    func setUpEditing() {
        headTitle.text = "  Szerkesztés"
        
        eventName.text = self.editedEvent?.getName()
        numOfPeople.text = self.editedEvent?.getParticipants()
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
            Int(numOfPeople.text!) ?? -1 > 0 &&
            shortDesc.text!.count > 10) &&
            (LocationSingleton.shared().getCoordinates() != nil &&
            !isOnlineSwitch.isOn ||
                isOnlineSwitch.isOn){
            return true
        } else {
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
                EventHandler.shared().sendToBackEnd(event: modifiedEvent, httpMethod: "PUT")
                disappearScreen()
            }
            else {
                let newEvent = createEvent()
                EventHandler.shared().addEvent(event: newEvent)
                EventHandler.shared().sendToBackEnd(event: newEvent, httpMethod: "POST")
                buttonMessage = "Létrehozva"
            }
            
            eventCreateButton.setTitle(buttonMessage, for: .normal)
            eventCreateButton.isEnabled = false
            clearScreen()
        }
     }
    
    func createEvent() -> Event {
        let event: Event
        var eventId = 0
        
        if isEditModeOn {
            eventId = self.editedEvent!.getEventId()
        }
        
        if isOnlineSwitch.isOn {
            event = Event(eventName: eventName.text!, eventLocation: "online", participants: numOfPeople.text!, subscribedParticipants: "0", shortDescription: shortDesc.text!, startDate: startDate.text!, endDate: endDate.text!, publicity: publicityInput.text!, image: imageView.image, address: "online", creatorID: Profile.shared().getID(), eventId: eventId)
        } else {
            event = Event(eventName: eventName.text!, eventLocation: LocationSingleton.shared().getCoordinates()!, participants: numOfPeople.text!, subscribedParticipants: "0", shortDescription: shortDesc.text!, startDate: startDate.text!, endDate: endDate.text!, publicity: publicityInput.text!, image: imageView.image, address: LocationSingleton.shared().getText(), creatorID: Profile.shared().getID(), eventId: eventId)
            event.setJoined(status: true)
        }
        return event
    }
    
    func editEvent(modifiedEvent: Event) {
        EventHandler.shared().editEvent(oldEvent: self.editedEvent!, modifiedEvent: modifiedEvent)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        disappearScreen()
    }
    
    func disappearScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    func clearScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.eventName.text = ""
            self.numOfPeople.text = ""
            self.startDate.text = ""
            self.endDate.text = ""
            self.isEndDateEnabled = false
            self.startDatePicking()
            self.shortDesc.text = ""
            self.isOnlineSwitch.setOn(false, animated: false)
            self.location.setTitle("Helyszín hozzáadása", for: .normal)
            self.eventCreateButton.setTitle("Esemény létrehozása", for: .normal)
            self.eventCreateButton.isEnabled = true
            self.location.isEnabled = true
            self.imageView.image = UIImage(systemName: "photo")
        }
    }
    
    //MARK: - Image Picker
    
    @IBAction func importImage(_ sender: Any) {
        imagePicker!.importImage(allowsEditing: false)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setChosenImage(image: image)
       }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setChosenImage(image: UIImage) {
        self.imageView.image = image
        self.image = image
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
        let currentDate = UIDatePicker().date
        
        self.datePicker!.setDatePicker(mode: .dateAndTime, textField: self.startDate, minimumDate: currentDate).addTarget(self, action: #selector(startDatePicker(datePicker:)), for: .valueChanged)
        }
    
    func endDatePicking() {
        let currentDate = self.datePicker.getSelectedDate()
        
        self.datePicker2!.setDatePicker(mode: .dateAndTime, textField: self.endDate, minimumDate: currentDate).addTarget(self, action: #selector(endDatePicker(datePicker:)), for: .valueChanged)
    }
    
    @objc func startDatePicker(datePicker: UIDatePicker) {
        self.datePicker.setSelectedDate(date: datePicker.date)
        dateChanged(datePicker: self.datePicker, uiDatePicker: datePicker)
    }
    @objc func endDatePicker(datePicker: UIDatePicker) {
        self.datePicker2.setSelectedDate(date: datePicker.date)
        dateChanged(datePicker: self.datePicker2, uiDatePicker: datePicker)
    }
    
    func dateChanged(datePicker: DatePicker, uiDatePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        datePicker.getTextField().text! = dateFormatter.string(from: uiDatePicker.date)
        
        if (!self.isEndDateEnabled) {
            self.isEndDateEnabled = true
            endDatePicking()
        }
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
        case "PubPicker":   publicityInput.inputAccessoryView = doneButton
                            break
        default: break
        }
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}
