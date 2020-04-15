//
//  ImagePicker.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 15..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

class ImagePicker {
    
    private var viewController: UIViewController
    private var image: UIImage?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func getImage() -> UIImage {
        return self.image!
    }
    
    func importImage() {
        let image = UIImagePickerController()
        image.delegate = (self.viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
           
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
           
        image.allowsEditing = false
           
        self.viewController.present(image, animated: true)
    }
 
} //end of the class
