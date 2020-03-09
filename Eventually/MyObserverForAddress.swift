//
//  MyObserverForAddress.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 09..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation

class MyObserverForAddress {
    private var observes: [PObserver] = []
    
    func attach(observer: PObserver){
        observes.append(observer)
    }
    func notify(){
        for observer in observes {
            observer.update()
        }
    }
}
