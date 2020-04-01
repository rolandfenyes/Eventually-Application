//
//  HomeScreenViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 11..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit
import MapKit

class HomeScreenViewController: UIViewController {

    //MARK: - Variables for horizontal stack view
    
    @IBOutlet weak var eventImage1: UIImageView!
    @IBOutlet weak var eventTitle1: UILabel!
    
    @IBOutlet weak var eventImage2: UIImageView!
    @IBOutlet weak var eventTitle2: UILabel!
    
    @IBOutlet weak var eventImage3: UIImageView!
    @IBOutlet weak var eventTitle3: UILabel!
    
    @IBOutlet weak var eventImage4: UIImageView!
    @IBOutlet weak var eventTitle4: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventHandler.shared().attach(observer: self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: - Sample events
        let event1 = Event(eventName: "Mozizás", eventLocation: CLLocationCoordinate2D(latitude: 47.474838443055546, longitude: 19.049048381857574), numberOfPeople: "3", shortDescription: "Szeretnék mozizni menni pár emberrel.", dateOfEvent: "holnap", publicity: "publikus", image: UIImage(named: "cinema"), address: "Allee")
        
        let event2 = Event(eventName: "Kajakozás", eventLocation: CLLocationCoordinate2D(latitude: 47.73254454163791, longitude: 19.051930750720203), numberOfPeople: "10", shortDescription: "Kajakozásra fel! A Dunakanyarban lakok, és nemrég nyílt a környéken egy új hely, ahol lehet bérelni kajakot. Olyan emberek jelentkezését várom, akik tudnak úszni, és szeretnének egy jót evezni,", dateOfEvent: "Szavazás alapján", publicity: "publikus", image: UIImage(named: "kayaking"), address: "Dunakanyar")
        
        let event3 = Event(eventName: "Burgerezés", eventLocation: CLLocationCoordinate2D(latitude: 47.37842513297852, longitude: 18.93373870756477), numberOfPeople: "3", shortDescription: "Sziasztok! Pár hete nyitott meg itt Érden a Burger King és szeretnék egy jót enni ott, viszont nincs kivel. Gondoltam ha van még valaki aki hasonló cipőben jár mint én, akkor itt majd találkozunk.", dateOfEvent: "Péntek este", publicity: "publikus", image: UIImage(named: "hamburger"), address: "Burger King Érd")
        
        let event4 = Event(eventName: "Sörözés", eventLocation: CLLocationCoordinate2D(latitude: 47.49810821206292, longitude: 19.066526661626995), numberOfPeople: "5", shortDescription: "A múltkori buli is jól sikerült, ezért most is meghirdetek egy sörözést a Fügébe péntek este 9-re, aki szeretne jönni jelentkezzen, múltkoriak előnyben!", dateOfEvent: "Péntek este 9", publicity: "privát", image: UIImage(named: "beers"), address: "Füge udvar Budapest")
        
        EventHandler.shared().addEvent(event: event1)
        EventHandler.shared().addEvent(event: event2)
        EventHandler.shared().addEvent(event: event3)
        EventHandler.shared().addEvent(event: event4)
        
        eventImage1.image = EventHandler.shared().getEvents()[0].getImage()
        eventTitle1.text = EventHandler.shared().getEvents()[0].getName()
        
        eventImage2.image = EventHandler.shared().getEvents()[1].getImage()
        eventTitle2.text = EventHandler.shared().getEvents()[1].getName()
        
        eventImage3.image = EventHandler.shared().getEvents()[2].getImage()
        eventTitle3.text = EventHandler.shared().getEvents()[2].getName()
        
        eventImage4.image = EventHandler.shared().getEvents()[3].getImage()
        eventTitle4.text = EventHandler.shared().getEvents()[3].getName()
        
        /*
         mozi: (latitude: 47.474838443055546, longitude: 19.049048381857574)
         kajak: (latitude: 47.73254454163791, longitude: 19.051930750720203)
         burger: (latitude: 47.37842513297852, longitude: 18.93373870756477)
         sör: (latitude: 47.49810821206292, longitude: 19.066526661626995)
         */
        //MARK: - End of Sample events
    }
    
    //MARK: - Events
    @IBAction func event1EventClicked(_ sender: Any) {
        presentEventScreen(event: EventHandler.shared().getEvents()[0])
    }
    @IBAction func event2ButtonClicked(_ sender: Any) {
        presentEventScreen(event: EventHandler.shared().getEvents()[1])
    }
    @IBAction func event3ButtonClicked(_ sender: Any) {
        presentEventScreen(event: EventHandler.shared().getEvents()[2])
    }
    @IBAction func event4ButtonClicked(_ sender: Any) {
        presentEventScreen(event: EventHandler.shared().getEvents()[3])
    }
    
    private func presentEventScreen(event: Event) {
        let eventScreen = self.storyboard?.instantiateViewController(withIdentifier: "eventScreen") as! EventScreenViewController
        eventScreen.setEvent(event: event)
        self.present(eventScreen, animated: true, completion: nil)
    }
} //end of the class

//MARK: - Set up tableview

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = EventHandler.shared().getEvents()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        
        cell.setEvent(event: event)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventHandler.shared().getEvents().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEventScreen(event: EventHandler.shared().getEvents()[indexPath.row])
    }
}

//MARK: - Observer

extension HomeScreenViewController: PObserver {
    
    func update() {
        self.tableView.reloadData()
    }
    
}
