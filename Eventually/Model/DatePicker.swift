//
//  DatePicker.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 15..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

class DatePicker {
    
    private var datePicker: UIDatePicker?
    private var date: Date?
    private var viewController: UIViewController!
    private var textField: UITextField?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        }
    
    func setDatePicker(mode: UIDatePicker.Mode, textField: UITextField, minimumDate: Date?) -> UIDatePicker {
        self.datePicker = UIDatePicker()
        self.textField = textField
        
        self.datePicker?.datePickerMode = .dateAndTime
        self.datePicker?.minimumDate = minimumDate
        self.textField!.inputView = self.datePicker
        
        setUpDoneButton()
        
        return self.datePicker!
    }
    
    func getTextField() -> UITextField {
        return self.textField!
    }
    func getSelectedDate() -> Date? {
        return self.date
    }
    func setSelectedDate(date: Date) {
        self.date = date
    }
    
    func setUpDoneButton() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self.viewController, action: #selector(DoneButtonPressed(sender: )))
        
        doneButton.tintColor = UIColor.black
        toolBar.setItems([space, doneButton], animated: true)
        toolBar.sizeToFit()
        
        self.textField?.inputAccessoryView = toolBar
    }
    
    @objc func DoneButtonPressed(sender: UIBarButtonItem) {
        self.viewController.view.endEditing(true)
    }
    
} //end of the class
