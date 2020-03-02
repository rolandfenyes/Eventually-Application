//
//  NewEventViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 02..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dateInput: UITextField!
    private var datePicker: UIDatePicker?
    
    @IBOutlet weak var publicityInput: UITextField!
    private var pubPicker: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DatePicking()
        PublicityPicking()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Publicity Picker
    
    private let dataSourceOfPubPicker = ["Publikus", "Privát", "Közeli ismerősök"]
    
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
        toolBar.setItems([space, doneButton], animated: false)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
