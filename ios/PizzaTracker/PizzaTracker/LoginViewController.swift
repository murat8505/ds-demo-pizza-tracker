//
//  LoginViewController.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // UI Outlets
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            self.usernameTextField.placeholder = "Login.Username".localized
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = "Login.Password".localized
        }
    }
    
    @IBOutlet weak var loginButtonPressed: UIButton!  {
        didSet {
            self.loginButtonPressed.setTitle("Login.SignIn".localized, forState: .Normal)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.becomeFirstResponder()
    }
    
    // UI Actions
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        guard let username = self.usernameTextField.text where !username.isEmpty() else {
            self.showAlert("Login.UsernameInvalid".localized)
            return
        }
        
        guard let password = self.passwordTextField.text where !password.isEmpty() else {
            self.showAlert("Login.PasswordInvalid".localized)
            return
        }
        
        self.activityIndicator.startAnimating()
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            // Setup Deepstream.io client
            guard let client = DeepstreamClient("138.68.154.77:6021") else {
                print("Error: Unable to init client")
                return
            }
            
            // Login
            
            let jsonAuthParams = JsonObject()
            jsonAuthParams.addPropertyWithNSString("username", withNSString: username)
            jsonAuthParams.addPropertyWithNSString("password", withNSString: password)
            
            let loginResult = client.loginWithJsonElement(jsonAuthParams)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (loginResult.loggedIn()) {
                    let trackingViewController = TrackingViewController(username: username, client: client)
                    self.presentViewController(trackingViewController, animated: true, completion: nil)
                } else {
                    self.showAlert("Login.PasswordIncorrect".localized)
                    self.activityIndicator.stopAnimating()
                }
            })
        })
    }
}
