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
    func showAlert(_ message: String, okPressed: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Alert.OK".localized, style: .default) { (alert) in
            okPressed?()
        }
        alertController.addAction(actionOk)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
