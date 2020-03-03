//
//  FirstViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 02. 20..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var forKey : String?;
    
    @IBOutlet weak var textInPut: UITextField!
    @IBOutlet weak var OutPUT: UILabel!
    
    @IBAction func Button(_ sender: Any) {
        OutPUT.text = textInPut.text;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

}
