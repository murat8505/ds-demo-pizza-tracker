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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: nil,
                message: "Alert.LocationAuthorizationDenied.Message".localized,
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Alert.Cancel".localized, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Alert.OpenSettings".localized, style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last
        else
        {
            print("No new location")
            return
        }
        
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        
        guard let recordHandler = self.client.record else {
            print("Error: unable to get recordHandler")
            return
        }
        
        do {
            try ObjC.catchException {
                if let record = recordHandler.getRecord(self.username),
                    let coords = JsonObject() {
                    
                    coords.addProperty(with: "lat", with: latitude as NSNumber!)
                    coords.addProperty(with: "lat", with: longitude as NSNumber!)
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
