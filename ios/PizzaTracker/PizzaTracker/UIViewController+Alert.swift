//
//  UIViewController+Alert.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showAlert(message: String, okPressed: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Alert.OK".localized, style: .Default) { (alert) in
            okPressed?()
        }
        alertController.addAction(actionOk)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}