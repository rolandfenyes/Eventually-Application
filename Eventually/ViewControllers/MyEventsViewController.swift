//
//  MyEventsViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 06..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class MyEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let myEvents: [Event] = EventHandler.shared().getMyEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventHandler.shared().attach(observer: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EventField", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func presentEventScreen(event: Event) {
        let eventScreen = self.storyboard?.instantiateViewController(withIdentifier: "eventScreen") as! EventScreenViewController
        eventScreen.setEvent(event: event)
        self.present(eventScreen, animated: true, completion: nil)
    }
    
}


extension MyEventsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = myEvents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        cell.setEvent(event: event)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEventScreen(event: EventHandler.shared().getExactEvent(event: myEvents[indexPath.row]))
    }
 
}

extension MyEventsViewController: PObserver {
    func update() {
        tableView.reloadData()
    }
}
