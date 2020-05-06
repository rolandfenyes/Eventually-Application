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

    //MARK: - Variables for event details
    
    private var event: Event!

    @IBOutlet weak var image: UIImageView?
    @IBOutlet weak var eventName: UILabel?
    @IBOutlet weak var participants: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var dateEnd: UILabel?
    @IBOutlet weak var publicity: UILabel?
    @IBOutlet weak var desc: UILabel?
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var map: MKMapView?
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var editBUtton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    func setEvent(event: Event) {
        self.event = event
    }
    
    //MARK: - Setting up the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setParameters()
        setJoinButtonTitle()
        setEditButton()
        setCornerRadiousForButtons()
        
        EventHandler.shared().attach(observer: self)
    }
    
    func setParameters() {
        //let eventImage =
        image?.image = self.event.getImage()
        eventName?.text = self.event.getName()
        date?.text = self.event.getStartDate()
        dateEnd?.text = self.event.getEndDate()
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
        
        self.map?.setRegion(region, animated: false)
        
        setParticipants()
    }
    
    func setParticipants() {
        let part = (((event?.getsubscribedParticipants())!)+"/"+(event?.getParticipants())!)
        participants!.text = part
    }
    
    //MARK: - Set corner radious for buttons
    func setCornerRadiousForButtons() {
        joinButton.layer.cornerRadius = 10
        commentButton.layer.cornerRadius = 10
        commentButton.setTitle("Kommentek(\(event.getComments().count))", for: .normal)
    }
    
    //MARK: - Join Button

    func setJoinButtonTitle() {
        if (!event.getIsJoined()) {
            joinButton.setTitle("Jelentkezés", for: .normal)
        }
        else {
            if (event.isPublic()) {
                joinButton.setTitle("Leiratkozás", for: .normal)
            }
            else if (!event.isPublic()) {
                joinButton.setTitle("Kérelem elküldve", for: .normal)
            }

        }
    }
    
    @IBAction func joinButtonClicked(_ sender: UIButton) {
        let eventIndex = EventHandler.shared().getExactEventIndex(event: self.event)
        if (!event.getIsJoined()) {
            EventHandler.shared().setJoinForAnEvent(status: true, index: eventIndex)
        }
        else {
            EventHandler.shared().setJoinForAnEvent(status: false, index: eventIndex)
        }
        setJoinButtonTitle()
    }
    
    //MARK: - Close Button
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Edit Button
    
    func setEditButton() {
        if (Profile.shared().getID() == self.event.getCreatorID()) {
            self.editBUtton.isHidden = false
        }
        else {
            self.editBUtton.isHidden = true
        }
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        //newEventScreen
        let editEventScreen = self.storyboard?.instantiateViewController(withIdentifier: "newEventScreen") as! NewEventViewController
        editEventScreen.setEventToEdit(event: self.event)
        self.present(editEventScreen, animated: true, completion: nil)
    }
    
    //MARK: - Open comments
    
    @IBAction func commentsButtonPressed(_ sender: UIButton) {
        presentCommentScreen()
    }
    
    private func presentCommentScreen() {
        let commentScreen = self.storyboard?.instantiateViewController(withIdentifier: "commentPage") as! CommentsViewController
        commentScreen.setCurrentEvent(event: event)
        self.present(commentScreen, animated: true, completion: nil)
    }
    
} // end of the class

extension EventScreenViewController: PObserver {
    func update() {
        viewDidLoad()
    }
}
