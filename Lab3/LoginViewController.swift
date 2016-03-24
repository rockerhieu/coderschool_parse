//
//  LoginViewController.swift
//  Lab3
//
//  Created by Hieu Rocker on 3/23/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            openChatScreen()
        }
    }
    
    @IBAction func onLoginTap(sender: UIButton) {
        login()
    }

    @IBAction func onSignUpTap(sender: UIButton) {
        signup()
    }
    
    func login() {
        PFUser.logInWithUsernameInBackground(emailView.text!, password: passwordView.text!) { (user: PFUser?, error: NSError?) -> Void in
            guard let user = user else {
                self.displayMessage(error!.userInfo["error"] as! String)
                return
            }
            
            print("Logging in as \(user.username)")
            self.openChatScreen()
        }
    }
    
    func openChatScreen() {
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    func signup() {
        let user = PFUser()
        user.username = emailView.text!
        user.password = passwordView.text!
        // user.email = "email@example.com"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as! String
                self.displayMessage(errorString)
            } else {
                self.openChatScreen()
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
    
    @IBAction func onLogoutCallback(segue: UIStoryboardSegue) {
        PFUser.logOut()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
