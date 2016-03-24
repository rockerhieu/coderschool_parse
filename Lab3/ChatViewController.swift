//
//  ChatViewController.swift
//  Lab3
//
//  Created by Hieu Rocker on 3/23/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputView: UITextField!
    @IBOutlet weak var sendView: UIButton!
    
    var messages: [PFObject]?
    let messageClassName = "Message_Swift_032016"

    override func viewDidLoad() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        loadMessages()
    }
    
    func loadMessages() {
        let query = PFQuery(className: messageClassName)
        query
            .includeKey("user")
            .findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            guard let objects = objects else {
                print("Error: \(error!.description)")
                return
            }

            print("loaded \(objects.count) messages")
            self.messages = objects
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func onSendTap(sender: UIButton) {
        sendMessage()
    }
    
    func sendMessage() {
        let message = PFObject(className: messageClassName)
        message["text"] = messageInputView.text!
        message["user"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.loadMessages()
            } else {
                let errorString = error!.userInfo["error"] as! String
                self.displayMessage(errorString)
            }
        }
    }
    
    func displayMessage(message: String) {
        let alertController = UIAlertController(
            title: "Alert",
            message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func onLogoutTap(sender: AnyObject) {
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        cell.message = self.messages![indexPath.row]
        return cell
    }
}
