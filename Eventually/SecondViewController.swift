//
//  SecondViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 02. 20..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "http://eventually.site/jsonexample"){
            do {
                let contents = try String(contentsOf: url)
                print(contents)
            } catch{
                
            }
        }
    }


}

