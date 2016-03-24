//
//  MessageCell.swift
//  Lab3
//
//  Created by Hieu Rocker on 3/23/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Parse
import NSDate_TimeAgo

class MessageCell: UITableViewCell {

    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    var message: PFObject? {
        didSet {
            messageView.text = message?["text"] as? String ?? ""
            if let user = message?["user"] as? PFUser {
                usernameView.text = user.username
            } else {
                usernameView.text = ""
            }
            timeView.text = message?.createdAt?.timeAgo() ?? ""
        }
    }
}
