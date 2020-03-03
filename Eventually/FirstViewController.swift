//
//  FirstViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 02. 20..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    @IBOutlet weak var eventName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        let events = NewEventHandler.getEventsFromList()
        if events.count > 0 {
            eventName.text = events[0].getName()
        }
    }
    
}
