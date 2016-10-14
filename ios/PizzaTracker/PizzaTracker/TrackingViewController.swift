//
//  TrackingViewController.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import UIKit
import CoreLocation

final class TrackingViewController: UIViewController {

    var client : DeepstreamClient!
    var record : Record?
    
    var locationManager : CLLocationManager!
    var username : String!
    
    init(username: String, client: DeepstreamClient) {
        print("Logged in with username: \(username)")
        self.client = client
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() == .notDetermined)
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
    }
}
