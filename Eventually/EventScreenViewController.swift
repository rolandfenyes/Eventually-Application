//
//  EventScreenViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 10..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit
import MapKit

class EventScreenViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var guests: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var publicity: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let event: Event = EventHandler.shared().getEvents()[0]
        image.image = event.getImage()
        eventName.text = event.getEventName()
        guests.text = event.getGuests()
        date.text = event.getDate()
        publicity.text = event.getPub()
        desc.text = event.getDescription()
        location.text = event.getAddress()
        
        let title = event.getAddress()
        let coordinates = event.getEventLocation()
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        self.map.addAnnotation(annotation)
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self .map.setRegion(region, animated: false)
    }

}
