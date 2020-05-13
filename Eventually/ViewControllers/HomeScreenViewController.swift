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
        
        setUpHorizontallyEvents()
        
        tableView.register(UINib(nibName: "EventField", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    func downloadEvents() {
        if (!isAlreadyDownloaded) {
            eventManager.downloadEvents()
            isAlreadyDownloaded = true
        }
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
