//
//  TrackingViewController+CLLocationManagerDelegate.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension TrackingViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: nil,
                message: "Alert.LocationAuthorizationDenied.Message".localized,
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Alert.Cancel".localized, style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Alert.OpenSettings".localized, style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        
        guard let recordHandler = self.client.record else {
            print("Error: unable to get recordHandler")
            return
        }
        
        do {
            try ObjC.catchException {
                if let record = recordHandler.getRecord(self.username) {
                    let coords = JsonObject()
                    coords.addPropertyWithNSString("lat", withNSNumber: latitude)
                    coords.addPropertyWithNSString("lat", withNSNumber: longitude)
                    record.set(coords)
                    print(coords)
                }
            }
        }
        catch let error {
            print("An error ocurred: \(error)")
        }

    }
}