//
//  CKPushNotificationProcessor.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

@objc public protocol CKPushNotificationProcessor {
    
    static var processorType: String { get }
    
    init(notification: [AnyHashable: Any])
    
    func process(application: UIApplication,
                 notification: [AnyHashable: Any],
                 fetchCompletionHandler: ((UIBackgroundFetchResult) -> Void)?)
}



