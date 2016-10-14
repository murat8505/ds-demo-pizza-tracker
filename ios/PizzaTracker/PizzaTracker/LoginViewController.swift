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
            self.loginButtonPressed.setTitle("Login.SignIn".localized, for: UIControlState())
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
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        guard let username = self.usernameTextField.text , !username.isEmpty else {
            self.showAlert("Login.UsernameInvalid".localized)
            return
        }
        
        guard let password = self.passwordTextField.text , !password.isEmpty else {
            self.showAlert("Login.PasswordInvalid".localized)
            return
        }
        
        self.activityIndicator.startAnimating()
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            // Setup Deepstream.io client
            guard let client = DeepstreamClient("138.68.154.77:6021") else {
                print("Error: Unable to init client")
                return
            }
            
            // Login
            
            guard let jsonAuthParams = JsonObject() else {
                print("Error: Unable to init JsonObject")
                return
            }
            
            jsonAuthParams.addProperty(with: "username", with: username)
            jsonAuthParams.addProperty(with: "password", with: password)
            
            guard let loginResult = client.login(with: jsonAuthParams) else {
                print("Error: Unable login")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if (loginResult.loggedIn()) {
                    let trackingViewController = TrackingViewController(username: username, client: client)
                    self.present(trackingViewController, animated: true, completion: nil)
                } else {
                    self.showAlert("Login.PasswordIncorrect".localized)
                    self.activityIndicator.stopAnimating()
                }
            })
        })
    }
}
