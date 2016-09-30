//
//  String+Localization.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

extension String
{
    var localized : String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
}