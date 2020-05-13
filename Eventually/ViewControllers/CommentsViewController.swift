//
//  CommentsViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 06..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    private var currentEvent: Event!
    private var comments: [Comment] = []
    
    func setCurrentEvent(event: Event) {
        self.currentEvent = event
        self.comments = self.currentEvent.getComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let comment = Comment(userid: Profile.shared().getNickname(), body: messageTextField.text!)
        comments.append(comment)
        EventHandler.shared().addComment(newComment: comment, event: currentEvent)
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = comments[indexPath.row].body
        return cell
    }
    
    
}
