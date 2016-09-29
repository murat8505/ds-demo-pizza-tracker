//
//  DeepstreamService.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final class DeepstreamService {
    
    static let sharedInstance = DeepstreamService()
    
    private var userName : String!
    private var deepstreamClient : DeepstreamClient!
    
    init() {
        self.deepstreamClient = DeepstreamClient("52.29.229.244:6021")
    }
}