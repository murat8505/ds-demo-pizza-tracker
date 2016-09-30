//
//  DeepstreamClient+Extensions.swift
//  PizzaTracker
//
//  Created by Akram Hussein on 30/09/2016.
//  Copyright © 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

typealias RecordSubscriptionCallbackHandler = ((recordName: String, path: String, data: JsonElement) -> Void)

class RecordSubscriptionCallback : NSObject, RecordPathChangedCallback {
    
    private var handler : RecordSubscriptionCallbackHandler!
    
    func onRecordPathChanged(recordName: String!, path: String!, data: JsonElement!) {
        print("\(recordName):\(path) = \(data)")
        self.handler(recordName: recordName, path: path, data: data)
    }
    
    init(handler: RecordSubscriptionCallbackHandler) {
        self.handler = handler
    }
}

class RuntimeHandler : NSObject, DeepstreamRuntimeErrorHandler {
    func onException(topic: Topic!, event: Event!, errorMessage: String!) {
        // TODO:
    }
}

extension DeepstreamClient
{
    var record : RecordHandler? {
        get {
            return self.valueForKey("record_") as? RecordHandler
        }
    }
}