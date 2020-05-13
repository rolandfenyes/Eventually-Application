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
    
    private var searchResult: [Event] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EventField", bundle: nil), forCellReuseIdentifier: "EventCell")
        EventHandler.shared().attach(observer: self)
    }
    
}

//MARK: - Search

extension SearchEventViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        activeSearch(search: searchBar.text ?? "")
    }
    
    func activeSearch(search: String) {
        searchResult.removeAll()
        let events = EventHandler.shared().getEvents()
        for event in events {
            if ((event.getName().uppercased()).contains(search.uppercased())) {
                searchResult.append(event)
            }
        }
        tableView.reloadData()
    }
}

//MARK: - TableView
extension SearchEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = searchResult[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        
        cell.setEvent(event: event)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEventScreen(event: EventHandler.shared().getExactEvent(event: searchResult[indexPath.row]))
    }
    
    private func presentEventScreen(event: Event) {
        let eventScreen = self.storyboard?.instantiateViewController(withIdentifier: "eventScreen") as! EventScreenViewController
        eventScreen.setEvent(event: event)
        self.present(eventScreen, animated: true, completion: nil)
    }
}

//MARK: - Observer
extension SearchEventViewController: PObserver {
    func update() {
        tableView.reloadData()
    }
}
