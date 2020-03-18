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

    private var event: Event!

    @IBOutlet weak var image: UIImageView?
    @IBOutlet weak var eventName: UILabel?
    @IBOutlet weak var guests: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var publicity: UILabel?
    @IBOutlet weak var desc: UILabel?
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var map: MKMapView?
    
    func setEvent(event: Event) {
        self.event = event
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventImage = self.event.getImage()
        
        image?.image = eventImage
        eventName?.text = self.event.getName()
        guests?.text = self.event.getGuests()
        date?.text = self.event.getDate()
        publicity?.text = self.event.getPub()
        desc?.text = self.event.getDescription()
        location?.text = self.event.getAddress()
        
        let title = self.event.getAddress()
        let coordinates = self.event.getEventLocation()
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        self.map?.addAnnotation(annotation)
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self .map?.setRegion(region, animated: false)
    }

}
