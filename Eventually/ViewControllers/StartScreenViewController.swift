//
//  StartScreenViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 14..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text? = ""
        var charIndex = 0.0
        let titleText = "Eventually"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }

}
