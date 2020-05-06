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
    
    private let eventManager = EventManager()
    private var isAlreadyDownloaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventHandler.shared().attach(observer: self)
        downloadEvents()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        createSampleEvents()
        setUpHorizontallyEvents()
        
        tableView.register(UINib(nibName: "EventField", bundle: nil), forCellReuseIdentifier: "EventCell")

        
        /*
        if (!self.areEventsDownloaded) {
            self.eventManager.downloadEvents()
            self.areEventsDownloaded = true
        }
        */
    }
    
    func downloadEvents() {
        if (!isAlreadyDownloaded) {
            eventManager.downloadEvents()
            isAlreadyDownloaded = true
        }
    }
    
    func createSampleEvents() {
        //MARK: - Sample events
        let event1 = Event(eventName: "Mozizás", eventLocation: CLLocationCoordinate2D(latitude: 47.474838443055546, longitude: 19.049048381857574), participants: "3", subscribedParticipants: "0", shortDescription: "Szeretnék mozizni menni pár emberrel.", startDate: "holnap", endDate: "valamikor", publicity: "Privát", image: UIImage(named: "cinema"), address: "Allee", creatorID: 1)
        
        let event2 = Event(eventName: "Kajakozás", eventLocation: CLLocationCoordinate2D(latitude: 47.73254454163791, longitude: 19.051930750720203), participants: "5", subscribedParticipants: "0", shortDescription: "Kajakozásra fel! A Dunakanyarban lakok, és nemrég nyílt a környéken egy új hely, ahol lehet bérelni kajakot. Olyan emberek jelentkezését várom, akik tudnak úszni, és szeretnének egy jót evezni,", startDate: "Szavazás alapján", endDate: "Szavazás alapján", publicity: "publikus", image: UIImage(named: "kayaking"), address: "Dunakanyar", creatorID: 1)
        
        let event3 = Event(eventName: "Burgerezés", eventLocation: CLLocationCoordinate2D(latitude: 47.37842513297852, longitude: 18.93373870756477), participants: "8", subscribedParticipants: "0", shortDescription: "Sziasztok! Pár hete nyitott meg itt Érden a Burger King és szeretnék egy jót enni ott, viszont nincs kivel. Gondoltam ha van még valaki aki hasonló cipőben jár mint én, akkor itt majd találkozunk.", startDate: "Péntek este", endDate: "Szombat hajnal", publicity: "publikus", image: UIImage(named: "hamburger"), address: "Burger King Érd", creatorID: 1)
        
        let event4 = Event(eventName: "Sörözés", eventLocation: CLLocationCoordinate2D(latitude: 47.49810821206292, longitude: 19.066526661626995), participants: "10", subscribedParticipants: "0", shortDescription: "A múltkori buli is jól sikerült, ezért most is meghirdetek egy sörözést a Fügébe péntek este 9-re, aki szeretne jönni jelentkezzen, múltkoriak előnyben!", startDate: "Péntek este 9", endDate: "Szombat hajnal", publicity: "Privát", image: UIImage(named: "beers"), address: "Füge udvar Budapest", creatorID: 1)
        
        EventHandler.shared().addEvent(event: event1)
        EventHandler.shared().addEvent(event: event2)
        EventHandler.shared().addEvent(event: event3)
        EventHandler.shared().addEvent(event: event4)
                
        /*
         mozi: (latitude: 47.474838443055546, longitude: 19.049048381857574)
         kajak: (latitude: 47.73254454163791, longitude: 19.051930750720203)
         burger: (latitude: 47.37842513297852, longitude: 18.93373870756477)
         sör: (latitude: 47.49810821206292, longitude: 19.066526661626995)
         */
        //MARK: - End of Sample events
        
    }
    
    //MARK: - Horizontally Events
    
    func setUpHorizontallyEvents() {
        var index = 0
        while index < EventHandler.shared().getEvents().count {
            if (index == 0) {
                eventImage1.image = EventHandler.shared().getEvents()[0].getImage()
                eventTitle1.text = EventHandler.shared().getEvents()[0].getName()
            } else if (index == 1) {
                eventImage2.image = EventHandler.shared().getEvents()[1].getImage()
                eventTitle2.text = EventHandler.shared().getEvents()[1].getName()
            } else if (index == 2) {
                eventImage3.image = EventHandler.shared().getEvents()[2].getImage()
                eventTitle3.text = EventHandler.shared().getEvents()[2].getName()
            } else if (index == 3) {
                eventImage4.image = EventHandler.shared().getEvents()[3].getImage()
                eventTitle4.text = EventHandler.shared().getEvents()[3].getName()
            }
            index += 1
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setUpHorizontallyEvents()
        }
    }
    
}
