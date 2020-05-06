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
    
    private var comments: [Comment] = [
        Comment(sender: "1@2.com", body: "Hey"),
        Comment(sender: "a@b.com", body: "Hello"),
        Comment(sender: "1@2.com", body: "How are you? I'm so fine, and finally I was able to program this code nicely")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        comments.append(Comment(sender: Profile.shared().getNickname(), body: messageTextField.text!))
        tableView.reloadData()
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
