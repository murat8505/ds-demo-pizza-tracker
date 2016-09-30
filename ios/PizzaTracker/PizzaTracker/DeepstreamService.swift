//
//  DeepstreamService.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

public final class DeepstreamService {
    
    static let sharedInstance = DeepstreamService()
    
    private (set) var deepstreamClient : DeepstreamClient!
    public var userName : String?
    
    init() {
        self.deepstreamClient = DeepstreamClient("52.29.229.244:6021")
    }
}