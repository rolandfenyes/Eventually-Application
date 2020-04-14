//
//  SearchEventViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 09..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

//MARK: - Main
class SearchEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: - Search

extension SearchEventViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //to be continued...
    }
}

//MARK: - TableView
extension SearchEventViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    private func presentEventScreen(event: Event) {
        let eventScreen = self.storyboard?.instantiateViewController(withIdentifier: "eventScreen") as! EventScreenViewController
        eventScreen.setEvent(event: event)
        self.present(eventScreen, animated: true, completion: nil)
    }
}
