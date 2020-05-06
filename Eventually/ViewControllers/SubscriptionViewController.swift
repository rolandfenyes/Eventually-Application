//
//  SubscriptionViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 06..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var myEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMyEvents()
        EventHandler.shared().attach(observer: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EventField", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    private func setMyEvents() {
        myEvents = []
        myEvents = EventHandler.shared().getSubscribedEvents()
    }
    
    private func presentEventScreen(event: Event) {
        let eventScreen = self.storyboard?.instantiateViewController(withIdentifier: "eventScreen") as! EventScreenViewController
        eventScreen.setEvent(event: event)
        self.present(eventScreen, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SubscriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension SubscriptionViewController: PObserver {
    func update() {
        tableView.reloadData()
    }
}
