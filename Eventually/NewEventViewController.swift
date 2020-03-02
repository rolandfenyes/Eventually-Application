//
//  NewEventViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 02..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

    @IBOutlet weak var dateInput: UITextField!
    private var datePicker : UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DatePicking()
        
        // Do any additional setup after loading the view.
    }
    
    func DatePicking() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewEventViewController.DateChanged(datePicker:)), for: .valueChanged)
        dateInput.inputView = datePicker
        SetUpDoneButton()
    }
    
    @objc func DateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd '-' hh:mm a"  //"hh:mm a 'on' dd"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateInput.text = dateFormatter.string(from: datePicker.date)
    }
    
    func SetUpDoneButton() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DoneDatePickerPressed(sender: )))
        doneButton.tintColor = UIColor.black
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.sizeToFit()
        AddDoneButtonToDatePicker(doneButton: toolBar)
    }
    
    func AddDoneButtonToDatePicker(doneButton : UIToolbar) {
        dateInput.inputAccessoryView = doneButton
    }
    
    @objc func DoneDatePickerPressed(sender: UIBarButtonItem) {
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
