//
//  HomeScreenViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 11..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func resizeImages(image: UIImageView) {
        image.contentMode = UIView.ContentMode.scaleAspectFit
    }
}

