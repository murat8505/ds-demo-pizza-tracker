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

    var locationManager : CLLocationManager!
    
    init() {
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
        
        if (CLLocationManager.authorizationStatus() == .NotDetermined)
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
    }
}
