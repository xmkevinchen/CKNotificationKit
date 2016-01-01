//
//  CKPushNotificationProcessor.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKPushNotificationProcessor : class {
    
    static func processorType() -> String
    
    init(notification:[NSObject: AnyObject])
    
    func process(application: UIApplication, notification:[NSObject: AnyObject], fetchCompletionHandler:(UIBackgroundFetchResult -> Void))
}



