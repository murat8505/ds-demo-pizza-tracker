//
//  DeepstreamClient+Extensions.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

extension DeepstreamClient
{
    var record : RecordHandler? {
        get {
            return self.valueForKey("record_") as? RecordHandler
        }
    }
}